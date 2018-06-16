# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class NewCollaborator
  # Error for inability of API to create account
  class InvalidCollaborator < StandardError
    def message
      'This collaborator cannot be added: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, proj_id, email)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/projects/#{proj_id}/collaborator",
                         json: email)

    raise InvalidCollaborator unless response.code == 201
  end
end
