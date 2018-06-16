# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class NewRequest
  # Error for inability of API to create account
  class InvalidRequest < StandardError
    def message
      'This project cannot be created: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, proj_id, data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/projects/#{proj_id}/request",
                         json: data)

    raise InvalidRequest unless response.code == 201
  end
end
