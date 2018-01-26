module VerificationRunners
  class HttpOkVerificationRunner

    def self.run(verifier)
      response = RestClient.get verifier.runner_params.find_by(name: 'url').value
      return response.code == 200
    end

    def self.required_parameters
      [:url]
    end
  end
end
