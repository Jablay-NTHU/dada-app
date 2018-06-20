# frozen_string_literal: true

require 'http'
require 'uri'

module Dada
  # Returns an authenticated user, or nil
  class AuthenticateGoogleAccount
    def initialize(config)
      @config = config
    end

    def call(code)
      # puts "code: #{code}"
      access_token = get_access_token_from_google(code)
      puts "access token:#{access_token}"
      get_sso_account_from_api(access_token)
    end

    private

    # def get_access_token_from_google(code)
    #   challenge_response =
    #     HTTP.headers(accept: 'application/x-www-form-urlencoded')
    #         .get(@config.GOOGLE_TOKEN_URL,
    #               json: { client_id: @config.GOOGLE_CLIENT_ID,
    #                       client_secret: @config.GOOGLE_CLIENT_SECRET,
    #                       code: uri.encode.(code) })
    #   puts "chal_resp: #{challenge_response}"

    #   raise unless challenge_response.status < 400
    #   challenge_response.parse['access_token']
    # end
    def get_access_token_from_google(code)
      challenge_response =
        HTTP.post(@config.GOOGLE_TOKEN_URL,
                  form: { code: code,
                          client_id: @config.GOOGLE_CLIENT_ID,
                          client_secret: @config.GOOGLE_CLIENT_SECRET,
                          redirect_uri: @config.GOOGLE_REDIRECT_URI,
                          grant_type: 'authorization_code' })
      puts "cha: #{challenge_response.status}"
      raise unless challenge_response.status < 400
      challenge_response.parse['access_token']
    end

    def get_sso_account_from_api(access_token)
      sso_info = { access_token: access_token }
      puts "info: #{sso_info}"
      signed_sso_info = SecureMessage.sign(sso_info)
      puts "signed: #{signed_sso_info}"

      response =
        HTTP.post("#{@config.API_URL}/auth/authenticate/google_account",
                  json: signed_sso_info)
      puts "res: #{response}"
      response.code == 200 ? response.parse : nil
    end
  end
end
