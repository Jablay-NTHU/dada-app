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

          routing.post do
            flash[:params] = routing.params

            project = Form::NewProject.call(routing.params)
            if project.failure?
              flash[:error] = Form.validation_errors(project)
              routing.redirect @project_route
            end
            CreateProject.new(App.config).call(@current_user, routing.params)

            flash[:notice] = 'New Project has been succesfully created'
            routing.redirect '/'
          rescue StandardError => error
            puts "ERROR CREATING PROJECT: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Project detail are not valid: please check...'
            routing.redirect @project_route
          end
        end

        # /project/[proj_id]
        routing.on(String) do |proj_id|
          @request_route = "/project/#{proj_id}"
          routing.is 'create_request' do
            # GET /project/create
            routing.get do
              routing.redirect '/' unless @current_user
              view '/request/new_request',
                   locals: { current_user: @current_user, action_post: @request_route },
                   layout_opts: { locals: { projects: @projects } }
            end
          end

          routing.is 'try' do
            routing.post do
              x = routing.params
              "#{x}"
              paracetamol = {}
              paracetamol['title'] = routing.params['title']
              paracetamol['description'] = routing.params['description']
              paracetamol['api_url'] = routing.params['api_url']
              paracetamol['parameters'] = routing.params['header'].to_yaml
              paracetamol['interval'] = routing.params['interval']
              paracetamol['status_code'] = routing.params['status_code']
              paracetamol['header'] = routing.params['header_secure']
              paracetamol['body'] = routing.params['body_secure']

            #   # project = Form::NewProject.call(routing.params)
            #   # if project.failure?
            #   #   flash[:error] = Form.validation_errors(project)
            #   #   routing.redirect '/'
            #   # end
              NewRequest.new(App.config).call(@current_user, proj_id, paracetamol)

              flash[:notice] = 'Request has been succesfully created'
              routing.redirect @request_route
            rescue StandardError => error
              puts "ERROR SAVING REQUEST: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Request detail are not valid: please check...'
              routing.redirect "#{@request_route}/create_request"
            end
          end

          # POST /project/[proj_id]/delete
          routing.on 'delete' do
            routing.post do
              DeleteProject.new(App.config).call(@current_user, proj_id)
              flash[:notice] = 'Project has been succesfully deleted'
              routing.redirect '/'
            rescue StandardError => error
              puts "ERROR DELETING PROJECT: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Project cannot be deleted: please try again'
              routing.redirect '/'
            end
          end

          # POST /project/[proj_id]/leave
          routing.on 'leave' do
            routing.post do
              LeaveProject.new(App.config).call(@current_user, proj_id)
              flash[:notice] = 'You have succesfully leaving a project'
              routing.redirect '/'
            rescue StandardError => error
              puts "ERROR LEAVING PROJECT: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'You cannot leave the project: please try again'
              routing.redirect '/'
            end
          end

          # POST /project/[proj_id]/edit
          routing.on 'edit' do
            # POST /project/[proj_id]/edit/[list or detail]
            routing.on String do |type|
              routing.post do
                flash[:params] = routing.params

                project = Form::NewProject.call(routing.params)
                if project.failure?
                  flash[:error] = Form.validation_errors(project)
                  routing.redirect '/'
                end
                EditProject.new(App.config).call(@current_user,
                                                 proj_id, routing.params)

                flash[:notice] = 'Project has been succesfully edited'
                routing.redirect "/project/#{proj_id}" if type == 'detail'
                routing.redirect '/'
              rescue StandardError => error
                puts "ERROR EDITING PROJECT: #{error.inspect}"
                puts error.backtrace
                flash[:error] = 'Project detail are not valid: please check...'
                routing.redirect "/project/#{proj_id}" if type == 'type'
                routing.redirect '/'
              end
            end
          end

          # POST /project/[proj_id]/add_collaborator
          routing.on 'add_collaborator' do
            # POST /project/[proj_id]/add_collaborator
            routing.post do
              flash[:params] = routing.params

              valid_email = Form::EmailAccount.call(routing.params)
              if valid_email.failure?
                flash[:error] = Form.validation_errors(valid_email)
                routing.redirect "/project/#{proj_id}"
              end

              NewCollaborator.new(App.config).call(@current_user,
                                                   proj_id, routing.params)

              flash[:notice] = 'Collaborator has been succesfully added'
              routing.redirect "/project/#{proj_id}"
            rescue StandardError => error
              puts "ERROR ADDING COLLABORATOR: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Collaborator detail are not valid: please check...'
              routing.redirect "/project/#{proj_id}"
            end
          end

          # POST /project/[proj_id]/remove_collaborator
          routing.on 'remove_collaborator' do
            # POST /project/[proj_id]/remove_collaborator
            routing.post do
              routing.post do
                RemoveCollaborator.new(App.config).call(@current_user, proj_id, routing.params)
                flash[:notice] = 'You have succesfully remove a collaborator'
                routing.redirect "/project/#{proj_id}"
              rescue StandardError => error
                puts "ERROR REMOVING COLLABORATOR: #{error.inspect}"
                puts error.backtrace
                flash[:error] = 'You cannot remove a collaborator: please try again'
                routing.redirect "/project/#{proj_id}"
              end
            end
          end

          # GET /project/[proj_id]
          routing.get do
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
end
