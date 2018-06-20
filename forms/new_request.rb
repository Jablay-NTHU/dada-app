# frozen_string_literal: true

require 'dry-validation'

module Dada
  module Form
    NewRequest = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/new_request.yml')
      end

      required(:title).filled
      required(:description).filled
      required(:api_url).filled
      required(:parameters).filled(:array?)
      required(:interval).filled
      required(:date_start).maybe
      required(:date_end).maybe
      required(:status_code).filled(:int?, eql?:200)
      required(:header).filled
      required(:body).filled

      rule(date_: %i[date_start date_end]) do |start, ends|
        start.lteq?(ends)
      end
    end
  end
end
