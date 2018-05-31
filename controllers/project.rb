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
          routing.redirect '/' unless @current_user
          view '/project/create', locals: { current_user: @current_user }
        end
      end
    end
  end
end
