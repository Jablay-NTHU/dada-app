# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('request') do |routing|
      routing.on do
        # GET /requests/
        routing.get(String) do |doc_id|
          if @current_user.logged_in?
            req_info = GetRequest.new(App.config)
                                 .call(@current_user, doc_id)
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
