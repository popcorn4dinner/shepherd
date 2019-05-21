module Enforcer
  class RuleViolationError < RuntimeError


    def reasons
      @reasons ||= []
    end

    def message
      @message.blank? ?  reasons.map(&:to_s) : message
    end

    def to_json
      {
        errors:    error,
        messages:   message,
        timestamp: Time.now.utc
      }.to_json
    end

    private

    def error
      reasons.empty? ? [error_for(self.class)] : reasons.map { |e| error_for(e.class) }
    end

    def error_for(error_class)
      class_name = error_class.name.split('::').last(2).join('_')
      class_name.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      class_name.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      class_name.downcase!
      class_name
    end

  end
end
