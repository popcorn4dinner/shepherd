module Enforcer
  class Validator

    attr_accessor :rules

    def verify(subject, action = nil)
      rules.apply_for subject, action
    end

    def validates(rules)
      @rules = Enforcer::RuleCollection.new(*rules)
    end
  end
end
