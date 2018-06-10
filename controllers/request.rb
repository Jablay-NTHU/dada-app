# frozen_string_literal: true

require 'roda'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('request') do |routing|
      routing.on do
        # GET /documents/
        routing.get(String) do |doc_id|
          if @current_user.logged_in?
            doc_info = GetRequest.new(App.config)
                                 .call(@current_user, doc_id)
            # puts "DOC: #{doc_info}"
            request = Request.new(doc_info)

            view '/request/list',
            locals: { current_user: @current_user, request: request }
          else
            routing.redirect '/auth/login'
          end
        end
      end
    end
  end
end
