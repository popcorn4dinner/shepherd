module Enforcer
  module Rules
    class BirthdayBelievable < Enforcer::Rule

      UNREALISTIC_AGE = 150.years

      error_message 'age is not believable'

      def violated_with?(subject)
        birthday = subject.to_date
        in_the_future?(birthday) || customer_unrealistically_old?(birthday)
      end

      private

      def in_the_future?(date)
        date > Date.current
      end

      def customer_unrealistically_old?(date)
        date < (Date.current - UNREALISTIC_AGE)
      end

    end
  end
end
