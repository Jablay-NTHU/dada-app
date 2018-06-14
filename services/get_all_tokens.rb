# frozen_string_literal: true

require 'http'

# Returns all tokens belonging to an account
class GetAllTokens
  def initialize(config)
    @config = config
  end

  def call(user)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/tokens")
    response.code == 200 ? response.parse : nil
  end
end
