# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('auth') do |routing| # rubocop:disable Metrics/BlockLength
      @login_route = '/auth/login'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          routing.redirect '/' if @current_account
          view :login,
               locals: { current_account: @current_account },
               layout: { template: 'layout_login' }
        end

        # POST /auth/login
        routing.post do
          logged_in_account = AuthenticateAccount.new(App.config).call(
            JsonRequestBody.symbolize(routing.params)
          )

          # session[:current_account] = account
          SecureSession.new(session).set(:current_account, logged_in_account)
          flash[:notice] = "Welcome back #{logged_in_account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username and password did not match our records'
          routing.redirect @login_route
        end
      end

      routing.is 'logout' do
        routing.get do
          # session[:current_account] = nil
          SecureSession.new(session).delete(:current_account)
          routing.redirect @login_route
        end
      end

      @register_route = '/auth/register'
      routing.on 'register' do
        routing.is do
          routing.get do
            view :register,
                 locals: { current_account: @current_account },
                 layout: { template: 'layout_login' }
          end

          routing.post do
            account_data = JsonRequestBody.symbolize(routing.params)
            VerifyRegistration.new(App.config).call(account_data)
            flash[:notice] = 'Please check your email verification'
            routing.redirect '/'
          rescue StandardError => error
            puts "ERROR CREATING ACCOUNT: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Account detail are not valid: please check...'
            routing.redirect @register_route
          end
        end

        routing.on String do |registration_token|
          routing.get do
            new_account = SecureMessage.decrypt(registration_token)
            view :register_confirm,
                 locals: { new_account: new_account,
                           registration_token: registration_token },
                 layout: { template: 'layout_login' }
          end
        end
      end
    end
  end
end
