# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class DeleteProject
  # Error for inability of API to create account
  class InvalidProject < StandardError
    def message
      'This project cannot be deleted: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(user, project_id)
    response = HTTP.auth("Bearer #{user.auth_token}")
                   .post("#{@config.API_URL}/projects/#{project_id}/delete")

    raise InvalidProject unless response.code == 201
  end
end
