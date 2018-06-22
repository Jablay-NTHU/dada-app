# frozen_string_literal: true

require_relative 'project'
require 'date'

module Dada
  # Behaviors of the currently logged in account
  class Request
    attr_reader :id, :title, :description, :call_url, :parameters, # basic info
                :interval, :date_start, :date_end, :next_request,
                :json_path, :xml_path, :updated_at, :created_at,
                :project, :responses, :policies # full details

    def initialize(info)
      @id           = info['id']
      @title        = info['title']
      @description  = info['description']
      @call_url     = info['call_url']
      @parameters   = info['parameters']
      @interval     = info['interval']
      @date_start   = process_date_start(info['date_start'])
      @date_end     = process_date_end(info['date_end'])
      @next_request = info['next_request']
      @json_path    = info['json_path']
      @xml_path     = info['xml_path']
      @created_at   = info['created_at']
      @updated_at   = info['updated_at']
      @project      = Project.new(info['project'])
      @responses    = process_responses(info['responses'])
      @policies     = OpenStruct.new(info['policies'])
    end

    private

    def process_date_start(date_start)
      return nil unless date_start
      Date.parse(date_start).strftime("%Y-%m-%d")
    end
    def process_date_end(date_end)
      return nil unless date_end
      Date.parse(date_end).strftime("%Y-%m-%d")
    end

    def process_responses(responses_info)
      return nil unless responses_info
      responses_info.map { |res_info| Response.new(res_info) }
    end
  end
end
