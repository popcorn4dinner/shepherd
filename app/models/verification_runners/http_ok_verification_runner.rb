module VerificationRunners
  class HttpOkVerificationRunner

    def run(verifier)
      response = RestClient.get health_endpoint
      return response.code == 200
    end

  end
end
