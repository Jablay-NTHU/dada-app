# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class DeleteRequest
  # Error for inability of API to create account
  class InvalidRequest < StandardError
    def message
      'This request cannot be deleted: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, request_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/requests/#{request_id}/delete")

    raise InvalidRequest unless response.code == 201
  end
end
