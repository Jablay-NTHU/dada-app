# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('token') do |routing|
      routing.on do
        # GET /token/
        routing.get do
          if @current_user.logged_in?
            token_list = GetAllTokens.new(App.config).call(@current_user)
            # puts "TOKEN: #{token_list}"
            tokens = Tokens.new(token_list)
            view '/token/tokens_list',
                 locals: { current_user: @current_user, tokens: tokens },
                 layout_opts: { locals: { projects: @projects } }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
