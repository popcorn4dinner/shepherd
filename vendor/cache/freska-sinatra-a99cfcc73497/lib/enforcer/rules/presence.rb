module Enforcer
  module Rules
    class Presence < Enforcer::Rule

      error_message "is not present"

      def violated_with?(subject)
        subject.blank?
      end
    end
  end
end
