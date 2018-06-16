# frozen_string_literal: true

require 'rack/session/redis'
require 'rack/ssl-enforcer'
require 'secure_headers'

module Dada
  # Configuration for the API
  class App < Roda
    configure do
      SecureSession.setup(config)
      SecureMessage.setup(config)
    end

    ONE_MONTH = 30 * 24 * 60 * 60 # in seconds

    configure :development, :test do
      # use Rack::Session::Cookie,
      #     expire_after: ONE_MONTH, secret: config.SESSION_SECRET

      # use Rack::Session::Pool,
      #     expire_after: ONE_MONTH

      use Rack::Session::Redis,
          expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end

    configure :production do
      use Rack::SslEnforcer, hsts: true

      use Rack::Session::Redis,
          expire_after: ONE_MONTH, redis_server: App.config.REDIS_URL
    end

    ## Uncomment to drop the login session in case of any violation
    # use Rack::Protection, reaction: :drop_session
    use SecureHeaders::Middleware

    # rubocop:disable Metrics/BlockLength
    SecureHeaders::Configuration.default do |config|
      config.cookies = {
        secure: true,
        httponly: true,
        samesite: {
          strict: true
        }
      }

      config.x_frame_options = 'DENY'
      config.x_content_type_options = 'nosniff'
      config.x_xss_protection = '1'
      config.x_permitted_cross_domain_policies = 'none'
      config.referrer_policy = 'origin-when-cross-origin'

      # note: single-quotes needed around 'self' and 'none' in CSPs
      config.csp = {
        report_only: false,
        preserve_schemes: true,
        default_src: %w['self'],
        worker_src: %w['self'],
        connect_src: %w[wss: https:],
        img_src: %w['self'],
        font_src: %w['self' https://maxcdn.bootstrapcdn.com http://fonts.gstatic.com],
        script_src: %w['self' 'unsafe-inline' http://cdnjs.cloudflare.com/ajax/libs/jquery-mousewheel/3.1.13/jquery.mousewheel.min.js https://maxcdn.bootstrapcdn.com https://ajax.googleapis.com/ajax/libs/webfont/1.6.16/webfont.js],
        style_src: %w['self' 'unsafe-inline' https://maxcdn.bootstrapcdn.com https://cdnjs.cloudflare.com http://fonts.googleapis.com],
        form_action: %w['self'],
        frame_ancestors: %w['none'],
        object_src: %w['none'],
        block_all_mixed_content: true,
        report_uri: %w[/security/report_csp_violation]
      }
    end
    # rubocop:enable Metrics/BlockLength

    route('security') do |routing|
      routing.post 'report_csp_violation' do
        puts "CSP VIOLATION: #{request.body.read}"
      end
    end
  end
end
