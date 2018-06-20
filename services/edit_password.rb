# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class EditPassword
  # Error for inability of API to create account
  class InvalidPassword < StandardError
    def message
      'This password cannot be edited: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, passwords)
    password = passwords.output
    password.delete(:new_password_confirm)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/accounts/password/edit",
                    json: password)
    response if response.code == 200
    raise InvalidPassword unless response.code == 201
  end
end
