# frozen_string_literal: true

module Verification
  module Runners
    class HttpOkVerificationRunner
      include Singleton

      def initialize(rest_client = RestClient)
        @rest_client = rest_client
      end

      def run(verifier)
        begin
          response = @rest_client.get verifier.runner_params.find_by(name: 'url').value
          response.code == 200
        rescue RestClient::Exception => e
          raise Verification::VerificationError, e.message
        end
      end

      def self.equired_parameters
        [:url]
      end
    end
  end
end
