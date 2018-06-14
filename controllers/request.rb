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
