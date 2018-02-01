# frozen_string_literal: true

module Verification
  module Runners
    class HealthVerificationRunner

      def initialize(rest_client = RestClient)
        @rest_client = rest_client
      end

      def self.run(verifier)
        response = @rest_client.get verifier.service.health_endpoint
        response.code == 200
      end

      def self.required_parameters
        []
      end
    end
  end
end
