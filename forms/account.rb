# frozen_string_literal: true

require 'dry-validation'

module Dada
  module Form
    ChangePassword = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/password.yml')

        def enough_entropy?(string)
          StringSecurity.entropy(string) >= 3.0
        end
      end

      required(:old_password).filled
      required(:new_password).filled
      required(:new_password_confirm).filled

      rule(password_entropy: [:new_password]) do |password|
        password.enough_entropy?
      end

      rule(passwords_match: %i[new_password new_password_confirm]) do |pass1, pass2|
        pass1.eql?(pass2)
      end
    end
    
    ChangeProfile = Dry::Validation.Params do
      configure do
        config.messages_file = File.join(__dir__, 'errors/profile.yml')

        def format?(profile)
          filename = profile[:filename]
          profile_format = [".png",".jpg"]
          profile_format.include?File.extname(filename)
        end
      end

      required(:profile).filled

      rule(right_format: [:profile]) do |profile|
        profile.format?
      end

    end
  end
end
