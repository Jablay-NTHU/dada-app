# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('auth') do |routing| # rubocop:disable Metrics/BlockLength
      @login_route = '/auth/login'
      @oauth_callback = '/auth/sso_callback'

      def gh_oauth_url(config)
        url = config.GH_OAUTH_URL
        client_id = config.GH_CLIENT_ID
        scope = config.GH_SCOPE

        "#{url}?client_id=#{client_id}&scope=#{scope}"
      end

      routing.is 'sso_callback' do
        # GET /auth/sso_callback
        routing.get do
          sso_account = AuthenticateGithubAccount
                        .new(App.config)
                        .call(routing.params['code'])

          # puts "#{sso_account}"
          current_user = User.new(sso_account['account'],
                                  sso_account['auth_token'])

          Session.new(SecureSession.new(session)).set_user(current_user)
          flash[:notice] = "Welcome #{current_user.username}!"
          routing.redirect '/project'
        rescue StandardError => error
          puts error.inspect
          puts error.backtrace
          flash[:error] = 'Could not sign in using Github'
          routing.redirect @login_route
        end
      end
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          routing.redirect '/' if @current_user.logged_in?
          view '/auth/login',
               locals: { gh_oauth_url: gh_oauth_url(App.config) },
               layout: { template: '/layout/layout_auth/main' }
        end

        # POST /auth/login
        routing.post do
          # authenticated = AuthenticateAccount.new(App.config).call(
          #   JsonRequestBody.symbolize(routing.params)
          # )
          flash[:params] = routing.params

          credentials = Form::LoginCredentials.call(routing.params)
          if credentials.failure?
            flash[:error] = 'Please enter both username and password'
            routing.redirect @login_route
          end

          authenticated = AuthenticateEmailAccount.new(App.config).call(credentials)
          # authenticated = AuthenticateAccount.new(App.config).call(credentials)

          current_user = User.new(authenticated['account'],
                                  authenticated['auth_token'])

          # SecureSession.new(session).set(:current_account, logged_in_account)

          Session.new(SecureSession.new(session)).set_user(current_user)
          flash[:notice] = "Welcome back #{current_user.username}!"
          routing.redirect '/'
        rescue StandardError => error
          puts "ERROR: #{error.inspect}"
          puts error.backtrace
          flash[:error] = 'Username and password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.is 'logout' do
        routing.get do
          # SecureSession.new(session).delete(:current_account)
          Session.new(SecureSession.new(session)).delete
          routing.redirect @login_route
        end
      end

      @forget_pwd = '/auth/forget_password'
      routing.is 'forget_password' do
        # GET /auth/forget_password
        routing.get do
          view 'auth/forget_password',
                locals: { current_user: @current_user },
                layout: { template: '/layout/layout_auth/main' }
        end

        # POST /auth/forget_password
        routing.post do
          flash[:params] = routing.params
          valid_email = Form::ValidEmail.call(routing.params)
          if valid_email.failure?
            flash[:error] = Form.validation_errors(valid_email)
            routing.redirect @forget_pwd
          end

          VerifyRecoveryEmail.new(App.config).call(routing.params['email'])
          flash[:notice] = 'Please check your email inbox'
          routing.redirect '/'
        rescue StandardError => error
          puts "ERROR SENDING RECOVERY EMAIL: #{error.inspect}"
          puts error.backtrace
          flash[:error] = 'Account detail are not valid: please check your email'
          routing.redirect @forget_pwd
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          # GET /auth/register
          routing.get do
            routing.redirect '/' if @current_user.logged_in?
            view '/auth/register',
                 locals: { current_user: @current_user },
                 layout: { template: '/layout/layout_auth/main' }
          end

          # POST /auth/register
          routing.post do
            flash[:params] = routing.params
            # account_data = JsonRequestBody.symbolize(routing.params)
            # VerifyRegistration.new(App.config).call(account_data)

            registration = Form::Registration.call(routing.params)

            if registration.failure?
              flash[:error] = Form.validation_errors(registration)
              routing.redirect @register_route
            end

            # puts "#{registration}"

            VerifyRegistration.new(App.config).call(registration)

            flash[:notice] = 'Please check your email verification'
            routing.redirect '/'
          rescue StandardError => error
            puts "ERROR CREATING ACCOUNT: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Account detail are not valid: please check...'
            routing.redirect @register_route
          end
        end

        # GET /auth/register/[registration_token]
        routing.on String do |registration_token|
          routing.get do
            flash.now[:notice] = 'Email Verified! Please choose a new password'
            new_account = SecureMessage.decrypt(registration_token)
            view '/auth/register_confirm',
                 locals: { new_account: new_account,
                           registration_token: registration_token },
                 layout: { template: '/layout/layout_auth/main' }
          end
        end
      end

      # /auth/[reset_password_token]/forget_password
      routing.on String do |reset_password_token|
        routing.on 'forget_password' do
          routing.get do
            flash.now[:notice] = 'Please create new password'
            reset_email = SecureMessage.decrypt(reset_password_token)
            puts "#{reset_email}"
            view 'auth/reset_password',
                locals: { reset_email: reset_email,
                          reset_password_token: reset_password_token },
                layout: { template: '/layout/layout_auth/main' }
          end
        end
      end
    end
  end
end
