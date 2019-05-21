module Freska
  module Auth
    module Rules
      class AudiencePresence < Enforcer::Rule

        protected

        def violated_with?(subject)
          subject[:aud].blank?
        end

        def error_message
          "no autience given"
        end

      end
    end
  end
end
