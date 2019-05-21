require 'sinatra/base'

module Freska
  module Auth
    module Interceptor
      BEARER_AUTH_HEADER = 'HTTP_AUTHORIZATION'

      module Helpers
        def authenticate!
          env['app.current_user'] = authenticator.authenticate(extract_auth_token(env))
        end

        private

        def authenticator
          @authenticator ||= Freska::Auth::Factory.new(settings).create_authenticator
        end

        def extract_auth_token(env)
          auth_header = env[BEARER_AUTH_HEADER]
          auth_header.present? ? auth_header.gsub('Bearer ', '') : ''
        end
      end

      def self.registered(app)
        app.helpers Freska::Auth::Interceptor::Helpers

        app.error Freska::Auth::ExpiredTokenError do
          status 401
          raised_error.to_json
        end

        app.error Freska::Auth::InvalidTokenError do
          status 401
          raised_error.to_json
        end
      end
    end
  end
end
