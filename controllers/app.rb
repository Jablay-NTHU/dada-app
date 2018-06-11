# frozen_string_literal: true

require 'roda'
require 'slim'
require 'slim/include'

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
      # @current_account = SecureSession.new(session).get(:current_account)
      @current_user = Session.new(SecureSession.new(session)).get_user

      if @current_user.logged_in?
        project_list = GetAllProjects.new(App.config).call(@current_user)
        @projects = Projects.new(project_list)
      end

      routing.public
      routing.assets
      routing.multi_route

      # GET /
      routing.root do
        if @current_user.logged_in?
          # project_list = GetAllProjects.new(App.config).call(@current_user)
          # projects = Projects.new(project_list)
          view '/project/projects_list',
               locals: { current_user: @current_user, projects: @projects },
               layout_opts: { locals: { projects: @projects } }
        else
          routing.redirect '/auth/login'
        end
      end
    end
  end
end
