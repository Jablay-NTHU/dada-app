# frozen_string_literal: true

require 'http'

module Dada
  # Returns an authenticated user, or nil
  class AuthenticateEmailAccount
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(username:, password:)
      credentials = { username: username, password: password }
      signed_credentials = SecureMessage.sign(credentials)
      response = HTTP.post("#{@config.API_URL}/auth/authenticate/email_account",
                           json: signed_credentials)

      raise(UnauthorizedError) unless response.code == 200
      response.parse
    end
  end
end
