module Enforcer
  module Rules
    class EmailFormat < Enforcer::Rule

      error_message 'invalid email address'

      def violated_with?(subject)
        !/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.match?(subject)
      end

    end
  end
end
