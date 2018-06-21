# frozen_string_literal: true

require 'http'

# Returns all projects belonging to an account
class GetAccount
  def initialize(config)
    @config = config
  end

  def call(user)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .get("#{@config.API_URL}/accounts/#{user.username}")
    # puts response.parse
    response.code == 200 ? response.parse : nil

  end
end