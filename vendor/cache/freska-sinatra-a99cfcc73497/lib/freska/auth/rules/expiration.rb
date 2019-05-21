module Freska
  module Auth
    module Rules
      class Expiration < Enforcer::Rule

        def violated_with?(subject)
          subject[:exp] < DateTime.current.utc
        end

        def error_message
          "token has expired"
        end
      end
    end
  end
end
