# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('project') do |routing|
      routing.on do
        routing.is do
          # GET /projects/
          routing.get do
            if @current_user.logged_in?
              # project_list = GetAllProjects.new(App.config).call(@current_user)
              # projects = Projects.new(project_list)
              view '/project/project_list/project_list',
                   locals: { current_user: @current_user, projects: @projects },
                   layout_opts: { locals: { projects: @projects } }
            else
              routing.redirect '/auth/login'
            end
          end
        end

        @project_route = '/project/create'
        routing.is 'create' do
          # GET /project/create
          routing.get do
            routing.redirect '/' unless @current_user
            view '/project/new_project',
                 locals: { current_user: @current_user },
                 layout_opts: { locals: { projects: @projects } }
          end
        end

        # GET /project/[proj_id]
        routing.get(String) do |proj_id|
          if @current_user.logged_in?
            proj_info = GetProject.new(App.config).call(@current_user, proj_id)

            routing.redirect '/error/404' if proj_info.nil?

            project = Project.new(proj_info)
            view '/project/project_detail/project_detail',
                 locals: { current_user: @current_user, project: project },
                 layout_opts: { locals: { projects: @projects } }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
