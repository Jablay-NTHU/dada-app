# frozen_string_literal: true

module Dada
  # Behaviors of the currently logged in account
  class Account
    attr_reader :username, :email, :profile

    def initialize(info)
      @username     = info['username']
      @email        = info['email']
      @profile      = info['profile']
    end
  end
end
