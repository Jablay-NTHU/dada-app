# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('error') do |routing| # rubocop:disable Metrics/BlockLength
      routing.is '404' do
        # GET /error/404
        routing.get do
          # routing.redirect '/' if @current_user.logged_in?
          view '/error/error_404',
               locals: { current_user: @current_user },
               layout: { template: '/layout/layout_error/main' }
        end
      end
    end
  end
end
