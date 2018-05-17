# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Credence API
  class App < Roda
    @login_route = 'auth/login'
    route('auth') do |routing|
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account = AuthenticateAccount.new(App.config).call(
            username: routing.params['username'],
            password: routing.params['password']
          )
          session[:current_account] = account
          flash[:notice] = "Welcome back #{account['username']}!"
          routing.redirect '/'
        rescue StandardError
          flash[:error] = 'Username and password did not match our records'
          routing.redirect '/auth/login'
        end
      end
      routing.is 'logout' do
        routing.get do
          session[:current_account] = nil
          routing.redirect '/auth/login'
        end
      end
    end
  end
end
