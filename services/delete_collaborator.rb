# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class RemoveCollaborator
  # Error for inability of API to create account
  class InvalidCollaborator < StandardError
    def message
      'You cannot leave the project: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, proj_id, data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/projects/#{proj_id}/remove_collaborator",
                         json: data)

    raise InvalidCollaborator unless response.code == 201
  end
end
