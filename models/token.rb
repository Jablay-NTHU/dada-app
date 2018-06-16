# frozen_string_literal: true

require_relative 'user'
# require 'ostruct'

module Dada
  # Behaviors of the currently logged in account
  class Token
    attr_reader :id, :name, :description, :value,
                :owner # full details

    def initialize(info)
      @id = info['id']
      @name = info['name']
      @description = info['description']
      @value = info['value']
      @owner = User.new(info['owner'])
      # @policies = OpenStruct.new(info['policies'])
    end
  end
end
