# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class ChangePassword
  # Error for inability of API to create account
  class InvalidChangePassword < StandardError
    def message
      'This password cannot be created: please start again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(account_data)
    signed_credentials = SecureMessage.sign(account_data)
    response = HTTP.post(
      "#{@config.API_URL}/accounts/change_password",
      json: signed_credentials
    )

    raise InvalidChangePassword unless response.code == 201
  end
end
