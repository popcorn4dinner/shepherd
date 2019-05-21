module Freska
  module Auth
    class Authenticator
      def initialize(decoder)
        @decoder = decoder
      end

      def authenticate(token)
        claims = @decoder.decode token

        config = config_for claims[:iss]
        verify_claims_with config, claims

        user = User.new
        user.auth_token = token
        user.type = config::USER_TYPE
        user.id = claims[:sub]

        user
      end

      private

      def verify_claims_with(config, claims)
        validator = ClaimsValidator.new config
        validator.verify(claims)
      end

      def config_for(issuer_type)
        case issuer_type
        when Configurations::Customers::ISSUER
          Configurations::Customers
        when Configurations::Machines::ISSUER
          Configurations::Machines
        else
          raise Freska::RuntimeError, "#{issuer_type} is no supported issuer"
        end
      end
    end
  end
end
