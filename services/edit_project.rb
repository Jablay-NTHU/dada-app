# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class EditProject
  # Error for inability of API to create account
  class InvalidProject < StandardError
    def message
      'This project cannot be deleted: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, project_id, project_data)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/projects/#{project_id}/edit",
                    json: project_data)

    raise InvalidProject unless response.code == 201
  end
end
