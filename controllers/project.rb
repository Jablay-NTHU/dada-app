# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('project') do |routing|
      @project_route = '/project/create'
      routing.is 'create' do
        # GET /project/create
        routing.get do
          routing.redirect '/' unless @current_user
          view '/project/create', locals: { current_user: @current_user }
        end

        # POST /project/create
        routing.post do
          project_data = JsonRequestBody.symbolize(routing.params)
          CreateProject.new(App.config).call(project_data)

          create_project = Form::NewProject.call(routing.params)
          if create_project.failure?
            flash[:error] = Form.validation_errors(create_project)
            routing.redirect @project_route
          end

          VerifyRegistration.new(App.config).call(registration)

          flash[:notice] = 'New Project has been succesfully created'
          routing.redirect '/'
        rescue StandardError
          # puts "ERROR CREATING ACCOUNT: #{error.inspect}"
          # puts error.backtrace
          flash[:error] = 'Project detail are not valid: please check...'
          routing.redirect @project_route
        end
        
      end
    end
  end
end
