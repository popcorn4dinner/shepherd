module Freska
  module Auth
    class MachineAuthorizer

      TOKEN_CACHE_KEY = 'machine_auth_token'

      def initialize(service, token_cache, issuer, decoder)
        @token_cache = token_cache
        @issuer = issuer
        @decoder = decoder
        @service = service
      end

      def token
        token = @token_cache.get TOKEN_CACHE_KEY if @token_cache.cached? TOKEN_CACHE_KEY

        unless token.present? && still_usable?(token)
          token = @issuer.issue_with type: :machine, subject: @service, audience: @service
          @token_cache.save TOKEN_CACHE_KEY, token
        end

        token
      end

      private

      def still_usable?(token)
        @decoder.decode token
      rescue ExpiredTokenError, InvalidTokenError
        false
      end
    end
  end
end
