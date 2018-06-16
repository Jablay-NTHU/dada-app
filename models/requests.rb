# frozen_string_literal: true

require_relative 'project'

module Dada
  # Behaviors of the currently logged in account
  class Requests
    attr_reader :all

    def initialize(requests_list)
      @all = requests_list.map do |req|
        Request.new(req)
      end
    end
  end
end
