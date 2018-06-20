# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class NewResponse
  # Error for inability of API to create account
  class InvalidResponse < StandardError
    def message
      'This response cannot be created: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, req_id, data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/requests/#{req_id}/response",
                         json: data)
    puts response
    raise InvalidResponse unless response.code == 201
  end
end
