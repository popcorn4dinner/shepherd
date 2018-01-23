# frozen_string_literal: true

module VerificationRunners
  class HealthVerificationRunner
    def self.run(verifier)
      response = RestClient.get verifier.service.health_endpoint
      response.code == 200
    end

    def self.required_parameters
      []
    end
  end
end
