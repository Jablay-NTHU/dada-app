# frozen_string_literal: true

require 'http'

# Returns an authenticated user, or nil
class CreateProject
  # Error for inability of API to create account
  class InvalidProject < StandardError
    def message
      'This project cannot be created: please try again'
    end
  end
  def initialize(config)
    @config = config
  end

  def call(project_data)
    response = HTTP.post(
      "#{@config.API_URL}/project/",
      json: project_data
    )

    raise InvalidAccount unless response.code == 201
  end
end
