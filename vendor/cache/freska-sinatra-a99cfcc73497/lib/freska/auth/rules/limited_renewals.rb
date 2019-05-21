module Freska
  module Auth
    module Rules
      class LimitedRenewals < Enforcer::Rule

        def initialize(max_renewals, field: nil, skip: [])
          @max_renewals = max_renewals
          @actions_to_skip = skip
          @field = field
        end

        protected

        def violated_with?(subject)
          subject[:renewals] > @max_renewals
        end

        def error_message
          "cannot be renewed so many times"
        end

      end
    end
  end
end
