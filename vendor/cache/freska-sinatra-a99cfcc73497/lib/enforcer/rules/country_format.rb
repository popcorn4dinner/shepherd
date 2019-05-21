module Enforcer
  module Rules
    class CountryFormat < Enforcer::Rule

      error_message 'has invalid format'

      def violated_with?(subject)
        !(/^[A-Z]{2}/.match?(subject) && subject.length == 2)
      end

    end
  end
end
