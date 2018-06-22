# frozen_string_literal: true

require 'roda'
require 'jsonpath'
require 'open-uri'

module Dada
  # Web controller for Dada API
  class App < Roda
    route('response') do |routing|
      # GET /response/list
      routing.on 'list' do
        routing.on String do |req_id|
          routing.get do
            routing.redirect '/' unless @current_user
            view '/response/response_detail',
                 locals: { current_user: @current_user }
          end
        end
      end

      routing.is 'export' do
        # GET /response/expert
        routing.post do
          body = routing.params['body']
          jsonpath = routing.params['json_path']
          json = <<-HERE_DOC "#{body}"
          HERE_DOC
          puts "json: #{json.length}"
          path = JsonPath.new(jsonpath)
          result = path.on(json)
          routing.redirect '/' unless @current_user
          view '/response/response_export',
            locals: { current_user: @current_user, result:result }
        end
      end
      # /response/[res_id]
      routing.on String do |res_id|
        # POST /response/[res_id]/delete
        routing.on 'delete' do
          routing.post do
            response = DeleteResponse.new(App.config).call(@current_user, res_id)
            request_id = response['data']['request']['id']
            flash[:notice] = 'Response has been succesfully deleted'
            routing.redirect "/request/#{request_id}"
          rescue StandardError => error
            puts "ERROR DELETING RESPONSE: #{error.inspect}"
            puts error.backtrace
            flash[:error] = 'Response cannot be deleted: please try again'
            routing.redirect "/request/#{project_id}"
          end
        end
      end
    end
  end
end
