# frozen_string_literal: true

require_relative 'project'

module Dada
  # Behaviors of the currently logged in account
  class Request
    attr_reader :id, :title, :description, :parameters, # basic info
                :interval, :date_start, :date_end,
                :json_path, :xml_path, :updated_at, :created_at,
                :project, :responses, :policies # full details

    def initialize(info)
      @id           = info['id']
      @title        = info['title']
      @description  = info['description']
      @parameters   = info['parameters']
      @interval     = info['interval']
      @date_start   = info['date_start']
      @date_end     = info['date_end']
      @json_path    = info['json_path']
      @xml_path     = info['xml_path']
      @created_at   = info['created_at']
      @updated_at   = info['updated_at']
      @project      = Project.new(info['project'])
      @responses    = process_responses(info['responses'])
      @policies     = OpenStruct.new(info['policies'])
    end

    private

    def process_responses(responses_info)
      return nil unless responses_info
      responses_info.map { |res_info| Response.new(res_info) }
    end
  end
end
