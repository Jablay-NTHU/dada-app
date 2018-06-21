# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CallApiNow
  # Error for inability of API to create account
  class InvalidCall < StandardError
    def message
      'This project cannot be created: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, req_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/requests/#{req_id}/request_call")
    raise InvalidCall unless response.code == 201
    response.code == 201 ? response.parse : nil
  end
end
