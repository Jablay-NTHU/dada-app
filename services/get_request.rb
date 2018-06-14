# frozen_string_literal: true

require 'http'

# Returns a request detail belonging to an account
class GetRequest
  def initialize(config)
    @config = config
  end

  def call(user, req_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/requests/#{req_id}")
    response.code == 200 ? response.parse : nil
  end
end
