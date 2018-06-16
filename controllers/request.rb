# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('request') do |routing|
      routing.on do
        @request_route = '/request/create'
        routing.is 'create' do
          # GET /project/create
          routing.get do
            routing.redirect '/' unless @current_user
            view '/request/new_request',
                 locals: { current_user: @current_user },
                 layout_opts: { locals: { projects: @projects } }
          end
        end

        routing.is 'try' do
          routing.post do
            x = routing.params
            paracetamol = {}
            paracetamol['title'] = routing.params['title']
            paracetamol['description'] = routing.params['description']
            paracetamol['api_url'] = routing.params['api_url']
            paracetamol['parameters'] = routing.params['header'].to_yaml
            paracetamol['interval'] = routing.params['interval']
            paracetamol['status_code'] = routing.params['status_code']
            paracetamol['header'] = routing.params['header_secure'].to_yaml
            paracetamol['body'] = routing.params['body_secure'].to_yaml

            # project = Form::NewProject.call(routing.params)
            # if project.failure?
            #   flash[:error] = Form.validation_errors(project)
            #   routing.redirect '/'
            # end
            NewRequest.new(App.config).call(@current_user, '3', paracetamol)

            flash[:notice] = 'Request has been succesfully edited'
            routing.redirect '/project/3'
          rescue StandardError => error
            puts "ERROR SAVING REQUEST: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Request detail are not valid: please check...'
            routing.redirect '/request/create'
          end
        end

        # POST /requests/[req_id]/delete
        routing.on String do |req_id|
          routing.on 'delete' do
            routing.post do
              DeleteRequest.new(App.config).call(@current_user, req_id)
              flash[:notice] = 'Request has been succesfully deleted'
              routing.redirect '/'
            rescue StandardError => error
              puts "ERROR DELETING PROJECT: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Request cannot be deleted: please try again'
              routing.redirect '/'
            end
          end

          routing.get do
            if @current_user.logged_in?
              req_info = GetRequest.new(App.config)
                                  .call(@current_user, req_id)

              routing.redirect '/error/404' if req_info.nil?

              # puts "REQ: #{req_info}"
              request = Request.new(req_info)
              view '/request/request_detail',
                  locals: { current_user: @current_user, request: request },
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
