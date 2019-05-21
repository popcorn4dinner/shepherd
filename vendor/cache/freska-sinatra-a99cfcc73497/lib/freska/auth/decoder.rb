require 'jwt'

module Freska
  module Auth
    class Decoder
      def initialize(public_key, algorithm)
        @public_key = public_key
        @algorithm = algorithm
      end

      def decode(token)
        make_usable decode_jwt token
      rescue JWT::ExpiredSignature
        raise ExpiredTokenError, 'auth token has expired. login again.'
      rescue JWT::DecodeError
        raise InvalidTokenError, 'the provided token is invalid'
      end

      private

      attr_reader :public_key

      def decode_jwt(token)
        JWT.decode token, OpenSSL::PKey::RSA.new(public_key), true, algorithm: @algorithm
      end

      def make_usable(payload)
        body = payload.first

        usable_claims = {}
        body.each do |claim, value|
          usable_claims[claim.to_sym] = date_claim?(claim) ? date_for(value) : value
        end
        usable_claims
      end

      def date_claim?(claim)
        %i[exp nbf iat].include?(claim.to_sym)
      end

      def date_for(claim_value)
        Time.at(claim_value).utc.to_datetime
      end
    end
  end
end
