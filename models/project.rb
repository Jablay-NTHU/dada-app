# frozen_string_literal: true

require_relative 'request'
require_relative 'user'
require 'ostruct'

module Dada
  # Behaviors of the currently logged in account
  class Project
    attr_reader :id, :title, :description, :public_url,
                :owner, :collaborators, :requests, :policies # full details

    def initialize(info)
      @id = info['id']
      @title = info['title']
      @description = info['description']
      @public_url = info['public_url']
      @owner = User.new(info['owner'])
      @collaborators = process_collaborators(info['collaborators'])
      @requests = process_requests(info['requests'])
      @policies = OpenStruct.new(info['policies'])
    end

    private

    def process_requests(requests_info)
      return nil unless requests_info
      requests_info.map { |req_info| Request.new(req_info) }
    end

    def process_collaborators(collaborators_info)
      return nil unless collaborators_info
      collaborators_info.map { |account_info| User.new(account_info) }
    end
  end
end
