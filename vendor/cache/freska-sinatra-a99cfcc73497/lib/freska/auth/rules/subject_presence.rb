module Freska
  module Auth
    module Rules
      class SubjectPresence < Enforcer::Rule

        protected

        def violated_with?(subject)
          subject[:sub].blank?
        end

        def error_message
          "no subject given"
        end

      end
    end
  end
end
