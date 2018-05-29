# frozen_string_literal: true

require 'roda'
require 'slim'

module Dada
  # Base class for Dada Web Application
  class App < Roda
    plugin :render, engine: 'slim', views: 'views',
                    layout: 'layout/layout_main/main'
    plugin :assets, css: ['style.bundle.css', 'vendors.bundle.css'],
                    path: 'assets'
    plugin :public, root: 'public'
    plugin :multi_route
    plugin :flash

    # 'vendors.bundle.js', 'scripts.bundle.js', 'dashboard.js'
    route do |routing|
      @current_account = SecureSession.new(session).get(:current_account)

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        registration_token = '1414r142131241421'
        routing.redirect '/auth/login' unless @current_account
        view '/project/home',
             locals: { current_account: @current_account }
      end
    end
  end
end
