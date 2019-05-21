module Freska
  module Auth
    class RemoteIssuer
      def initialize(rest_client)
        @rest_client = rest_client
      end

      def issue_with(type:, subject:, audience: nil)
        response = @rest_client.post('/v2/auth-tokens/', body: { type: type, subject: subject, audience: audience })

        if response.ok?
          response.body['auth_token']
        else
          message = response.body.is_a?(Hash) ? response.body['messages'].to_sentence : response.body
          raise Freska::RuntimeError, message
        end
      end

      def renew(token)
        response = @rest_client.patch('/v2/auth-tokens/', body: { auth_token: token })

        case response.status
        when 200
          response.body['auth_token']
        when 403
          raise ExpiredTokenError, "token was already expired"
        when 500
          raise InvalidTokenError, response.body
        else
          raise Freska::RuntimeError, "token renewal went terribly wrong!"
        end
      end
    end
  end
end
