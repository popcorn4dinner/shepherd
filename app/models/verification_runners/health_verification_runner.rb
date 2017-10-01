module VerificationRunners
  class HttpOkVerificationRunner
    
    def run(verifier)
      response = RestClient.get verifier.runner_params.url
      return response.code == 200
    end

    def self.required_parameters
      [:url]
    end

  end
end
