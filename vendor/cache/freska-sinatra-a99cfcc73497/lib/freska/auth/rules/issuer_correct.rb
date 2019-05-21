module Freska
  module Auth
    module Rules
      class IssuerCorrect < Enforcer::Rule

        def initialize(issuer, field: nil, skip: [])
          @actions_to_skip = skip
          @field = field
          @issuer = issuer
        end

        protected

        def violated_with?(subject)
          !subject[:iss].to_s.eql?(@issuer)
        end

        def error_message
          "wrong issuer"
        end

      end
    end
  end
end
