module Verification
  class Result
    attr_accessor :success, :message, :target_name, :verifier_name

    def initialize(target_name = nil, verifier_name = nil)
      @verifier_name = verifier_name
      @target_name = target_name
    end

    def to_h
      {
        verifier_name: verifier_name,
        success: success,
        message: message,
        target_name: target_name
      }
    end

    def self.from_h(hashed_data)
      result = new
      hashed_data.each do |property, value|
        result.send("#{property}=", value)
      end

      result
    end
  end
end
