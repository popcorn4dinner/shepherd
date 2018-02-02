module Verification
  class Result
    attr_accessor :success, :message, :target_name, :verifier_name

    def initialize(target_name, verifier_name)
      @verifier_name = verifier_name
      @target_name = target_name
    end

    def to_json
      {
        verifier: verifier_name,
        success: success,
        message: message,
        tested_service: target_name
      }
    end

    def from_json(hashed_data)
      hashed_data.each do |property, value|
        send("#{property}=", value)
      end
    end
  end
end
