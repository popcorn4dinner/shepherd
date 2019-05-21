module Enforcer
  class RuleCollection

    def initialize(*rules)
      @rules = rules
      @error = RuleViolationError.new
    end

    def apply_for(subject, action = nil)
      valid = true

      @rules.each do |rule|
        valid &&= violates?(rule, subject, action)
      end

      valid || raise_error
    end

    def <<(rule)
      @rules << rule
    end

    private

    def raise_error
      raise @error
    end

    def violates?(rule, subject, action)
      rule.apply_for(subject, action)
    rescue RuleViolationError => rule_error
      @error.reasons << rule_error
      false
    end

  end
end
