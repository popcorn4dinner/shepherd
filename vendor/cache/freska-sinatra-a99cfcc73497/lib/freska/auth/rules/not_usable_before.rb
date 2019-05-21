module Freska
  module Auth
    module Rules
      class NotUsableBefore < Enforcer::Rule

        protected

        def violated_with?(subject)
          in_the_future?(subject[:nbf])
        end

        def error_message
          "token cannot be used yet"
        end

        private

        def in_the_future?(nbf_claim)
          Time.at(nbf_claim).to_datetime > DateTime.current
        end

      end
    end
  end
end
