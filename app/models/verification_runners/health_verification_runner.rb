module VerificationRunners
  class HealthVerificationRunner

    def self.run(verifier)
      response = RestClient.get verifier.service.health_endpoint
      return response.code == 200
    end

    def self.required_parameters
      []
    end

  end
end
