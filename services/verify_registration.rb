# frozen_string_literal: true

# Encrypt registration data for sending email
class VerifyRegistration
  class RegistrationVerification < StandardError; end

  def initialize(config)
    @config = config
  end

  def call(registration_data)
    registration_token = SecureMessage.encrypt(registration_data)
    registration_data['verification_url'] =
      "#{@config.APP_URL}/auth/register/#{registration_token}"

    response = HTTP.post("#{@config.API_URL}/auth/register",
                         json: registration_data)

    raise(RegistrationVerificationError) unless response.code == 201
    response.parse
  end
end
