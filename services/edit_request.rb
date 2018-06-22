# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class EditRequest
  # Error for inability of API to create account
  class InvalidRequest < StandardError
    def message
      'This request cannot be edited: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, request_id, request_data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/requests/#{request_id}/edit",
                    json: request_data)

    raise InvalidRequest unless response.code == 201
  end
end
