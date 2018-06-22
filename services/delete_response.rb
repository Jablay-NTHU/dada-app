# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class DeleteResponse
  # Error for inability of API to create account
  class InvalidResponse < StandardError
    def message
      'This request cannot be deleted: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, response_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/responses/#{response_id}/delete")
    # puts response
    raise InvalidResponse unless response.code == 201
    response.code == 201 ? response.parse : nil
  end
end
