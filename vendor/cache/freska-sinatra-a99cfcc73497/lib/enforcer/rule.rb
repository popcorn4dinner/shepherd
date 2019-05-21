module Enforcer
  class Rule
    class_attribute :error_class
    class_attribute :error_message_text

    def initialize(field: nil, skip: [])
      @actions_to_skip = skip
      @field = field
    end

    def apply_for(subject, action = nil)
      return true unless applies_for subject, action

      to_test = @field.present? ? subject.send(@field) : subject
      !violated_with?(to_test) || raise_error
    end

    def self.error_message(message)
      self.error_message_text = message
    end

    protected

    def applies_for(subject, action)
      !@actions_to_skip.include? action
    end

    private

    def error_message
      @field.present? ? "#{@field} #{self.error_message_text}" : self.error_message_text
    end

    def raise_error
      raise rule_error, error_message
    end

    def rule_error
      self.error_class ||= create_error_class
    end

    def create_error_class
      if self.class.const_defined?('Error')
        self.class.const_get('Error')
      else
        self.class.const_set('Error', Class.new(Enforcer::RuleViolationError))
      end
    end
  end
end
