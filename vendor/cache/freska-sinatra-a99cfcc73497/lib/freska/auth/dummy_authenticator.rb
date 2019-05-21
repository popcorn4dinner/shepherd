module Freska
  module Auth
    class DummyAuthenticator
      def initialize(user_type)
        @user_type = user_type
      end

      def authenticate(token)
        raise InvalidTokenError if token == 'invalid-token'

        user = User.new
        user.id = SecureRandom.uuid
        user.type = @user_type.to_sym
        user.auth_token = 'this_is_not_a_real_token'
        user
      end
    end
  end
end
