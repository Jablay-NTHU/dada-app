# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('account') do |routing|
      # POST /account/password/edit
      routing.on 'password' do
        routing.on 'edit' do
          routing.post do
            passwords = Form::ChangePassword.call(routing.params)
            if passwords.failure?
              flash[:error] = Form.message_values(passwords)
              routing.redirect "/account/#{@current_user.username}"
            end
          EditPassword.new(App.config).call(@current_user,passwords)
          flash[:notice] = "The password is changed!"
          routing.redirect "/account/#{@current_user.username}"
          rescue StandardError => error
            puts "ERROR: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Enter the correct old password'
            routing.redirect "/account/#{@current_user.username}"
          end
        end
      end

      routing.on do
        # GET /account/[username]
        routing.get String do |username|
          if @current_user && @current_user.username == username
            view '/account/account', locals: { current_user: @current_user }
          else
            routing.redirect '/auth/login'
          end
        end

        routing.post String do |registration_token|
          # raise 'Passwords do not match or empty' if
          #   routing.params['password'].empty? ||
          #   routing.params['password'] != routing.params['password_confirm']

          passwords = Form::Passwords.call(routing.params)
          if passwords.failure?
            flash[:error] = Form.message_values(passwords)
            routing.redirect "/auth/register/#{registration_token}"
          end

          new_account = SecureMessage.decrypt(registration_token)
          CreateAccount.new(App.config).call(
            email: new_account['email'],
            username: new_account['username'],
            password: routing.params['password']
          )
          flash[:notice] = 'Account created! Please login'
          routing.redirect '/auth/login'
        rescue CreateAccount::InvalidAccount => error
          puts error.backtrace
          flash[:error] = error.message
          routing.redirect '/auth/register'
        rescue StandardError => error
          puts error.backtrace
          flash[:error] = error.message
          routing.redirect(
            "#{App.config.APP_URL}/auth/register/#{registration_token}"
          )
        end
      end
    end
  end
end
