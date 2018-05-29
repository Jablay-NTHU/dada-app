# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('project') do |routing|
      # @login_route = '/project/create'
      routing.is 'create' do
        # GET /project/create
        routing.get do
          routing.redirect '/' unless @current_account
          view '/project/create', locals: { current_account: @current_account }
        end
      end
    end
  end
end
