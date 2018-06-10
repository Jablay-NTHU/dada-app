# frozen_string_literal: true

require_relative 'project'

module Dada
  # Behaviors of the currently logged in account
  class Response
    attr_reader :id, :status_code, :header, :body, :created_at, # basic info
                :request # full details

    def initialize(info)
      @id           = info['id']
      @status_code  = info['status_code']
      @header       = info['header']
      @body         = info['body']
      @created_at   = info['created_at']
      @request      = Request.new(info['request'])
    end
  end
end
