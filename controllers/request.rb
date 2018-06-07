# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('request') do |routing|
      # GET /request/list
      routing.on 'list' do
        routing.on String do |proj_id|
          routing.get do
            routing.redirect '/' unless @current_user
            view '/request/list', locals: { current_user: @current_user }
          end
        end
      end
      # @login_route = '/project/create'
      routing.is 'create' do
        # GET /request/create
        routing.get do
          routing.redirect '/' unless @current_user
          view '/request/create', locals: { current_user: @current_user }
        end
      end
    end
  end
end
