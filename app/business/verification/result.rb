module Verification
  class Result
    attr_accessors :success, :message, :target_name, :verifier_name

    def to_json
      {
        verifier: verifier_name,
        success: success,
        message: message,
        tested_service: target_name
      }
    end
  end
end
