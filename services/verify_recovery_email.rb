# frozen_string_literal: true

require 'http'
# Encrypt recovery email data for sending email
module Dada
  class VerifyRecoveryEmail
    class VerifyRecoveryEmailError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(email)
      password_recovery_data = { email: email } 
      password_recovery_token = SecureMessage.encrypt(password_recovery_data)
      password_recovery_data['verification_url'] =
        "#{@config.APP_URL}/auth/#{password_recovery_token}/forget_password"
      response = HTTP.post("#{@config.API_URL}/auth/forget_password",
                           json: password_recovery_data)
      raise(VerifyRecoveryEmailError) unless response.code == 201
      response.parse
    end
  end
end
