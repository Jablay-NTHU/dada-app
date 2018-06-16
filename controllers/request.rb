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
            "1. Title: #{x['title']}"
            "2. Description: #{x['description']}"
            "3. Api URL: #{x['api_url']}"
            "4. Header: #{x['header'].to_yaml}"
            "5. Interval: #{x['interval']}"
            "6. Status Code: #{x['status_code']}"
            "7. Header Code: #{x['header_secure'].to_yaml}"
            "8. Body Code: #{x['body_secure'].to_yaml}"

            paracetamol = {}
            paracetamol['title'] = x['title']
            paracetamol['description'] = x['description']
            paracetamol['api_url'] = x['api_url']
            paracetamol['parameters'] = x['header'].to_yaml
            paracetamol['interval'] = x['interval']
            paracetamol['status_code'] = x['status_code']
            paracetamol['header'] = x['header_secure'].to_yaml
            paracetamol['body'] = x['body_secure'].to_yaml

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
        # GET /requests/[req_id]
        routing.get(String) do |req_id|
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
