module Freska
  module Auth
    class User
      attr_accessor :auth_token, :id, :type

      def machine?
        type == Configurations::Machines::USER_TYPE
      end

      def customer?
        type == Configurations::Customers::USER_TYPE
      end
    end
  end
end
