require 'lightly'

module Freska
  module Auth
    class Factory
      ISSUER_SERVICE_NAME = 'issuer'

      def initialize(settings, rest_client_factory = nil)
        @settings = settings
        @rest_client_factory = rest_client_factory
      end

      def create_authenticator
        if @settings.framework.respond_to?(:simulate_auth_with)
          DummyAuthenticator.new(@settings.framework.simulate_auth_with)
        else
          Authenticator.new(create_decoder)
        end
      end

      def create_issuer
        RemoteIssuer.new rest_client_factory.client_for ISSUER_SERVICE_NAME
      end

      def create_decoder
        verify_auth_settings!

        public_key = File.read @settings.framework.auth_key_path
        Decoder.new public_key, Core::ALGORITHM
      end

      def create_machine_authorizer
        @machine_authorizer ||= MachineAuthorizer.new @settings.app.name, Lightly.new, create_issuer, create_decoder
      end

      private

      def verify_auth_settings!
        raise Freska::ConfigurationError, "auth_key_path not defined in config" unless @settings.framework.respond_to?(:auth_key_path)
      end

      def rest_client_factory
        @rest_client_factory ||= Freska::Rest::ClientFactory.new @settings
      end

    end
  end
end
