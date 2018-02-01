# frozen_string_literal: true

module Verification
  module Runners
    class HttpOkVerificationRunner

      def initialize(rest_client = RestClient)
        @restClient = rest_client
      end

      def self.run(verifier)
        response = @rest_client.get verifier.runner_params.find_by(name: 'url').value
        response.code == 200
      end

      def self.required_parameters
        [:url]
      end
    end
  end
end
