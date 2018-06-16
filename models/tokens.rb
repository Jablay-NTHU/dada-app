# frozen_string_literal: true

require_relative 'token'

module Dada
  # Behaviors of the currently logged in account
  class Tokens
    attr_reader :all

    def initialize(tokens_list)
      @all = tokens_list.map do |token|
        Token.new(token)
      end
    end
  end
end
