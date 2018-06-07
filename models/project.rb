# frozen_string_literal: true

require_relative 'project'

module Dada
  # Behaviors of the currently logged in account
  class Project
    attr_reader :id, :title, :description, :public_url

    def initialize(proj_info)
      @id = proj_info['data']['attributes']['id']
      @title = proj_info['data']['attributes']['title']
      @description = proj_info['data']['attributes']['description']
      @public_url = proj_info['data']['attributes']['public_url']
    end
  end
end
