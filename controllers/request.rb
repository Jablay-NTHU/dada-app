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

        # POST /requests/[req_id]/delete
        routing.on String do |req_id|
          # GET /response/[res_id]/add_response
          routing.on 'add_response' do
            routing.get do
              response = CallApiNow.new(App.config).call(@current_user, req_id)
              # "calling the api now #{response}"
              request_id = response['data']['id']
              flash[:notice] = 'New Api Call has been succesfully done'
              routing.redirect "/request/#{request_id}"
            rescue StandardError => error
              puts "ERROR DELETING RESPONSE: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'There something wrong with Api Call: please try again'
              routing.redirect "/request/#{project_id}"
            end
          end

          routing.on 'delete' do
            routing.post do
              request = DeleteRequest.new(App.config).call(@current_user, req_id)
              project_id = request['data']['project']['id']
              flash[:notice] = 'Request has been succesfully deleted'
              routing.redirect "/project/#{project_id}"
            rescue StandardError => error
              puts "ERROR DELETING PROJECT: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Request cannot be deleted: please try again'
              routing.redirect "/project/#{project_id}"
            end
          end

          routing.on 'edit' do
            routing.post do
              flash[:params] = routing.params
              proj_id = routing.params['project_id']
              # request = Form::EditRequest.call(routing.params)
              # if request.failure?
              #   flash[:error] = Form.validation_errors(request)
              #   routing.redirect '/'
              # end
              EditRequest.new(App.config).call(@current_user,
                                               req_id, routing.params)
              flash[:notice] = 'Request has been succesfully edited'
              routing.redirect "/project/#{proj_id}"
            rescue StandardError => error
              puts "ERROR EDITING PROJECT: #{error.inspect}"
              puts error.backtrace
              flash[:error] = 'Request detail are not valid: please check...'
              routing.redirect "/project/#{proj_id}"
            end
          end

          routing.get do
            if @current_user.logged_in?
              req_info = GetRequest.new(App.config)
                                  .call(@current_user, req_id)

              routing.redirect '/error/404' if req_info.nil?

              # # puts "REQ: #{req_info}"
              request = Request.new(req_info)
              view '/request/request_detail/request_detail',
                  locals: { current_user: @current_user, req_info: request },
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
