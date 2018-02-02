# frozen_string_literal: true

module Verification
  module Runners
    class HealthVerificationRunner
      include Singleton

      def initialize(rest_client = RestClient)
        @rest_client = rest_client
      end

      def run(verifier)
        begin
          response = @rest_client.get verifier.service.health_endpoint_url
          response.code == 200
        rescue RestClient::Exception => e
          raise Verification::VerificationError, e.message
        end
      end

      def self.required_parameters
        []
      end
    end
  end
end
