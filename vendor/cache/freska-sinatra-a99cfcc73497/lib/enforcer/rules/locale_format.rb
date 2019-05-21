module Enforcer
  module Rules
    class LocaleFormat < Enforcer::Rule

      error_message 'invalid locale format'

      def violated_with?(subject)
        !( /^([a-z]{2})-([a-z]{2})/.match?(subject) && subject.length == 5 )
      end

    end
  end
end
