module Freska
  module Auth
    class ClaimsValidator < Enforcer::Validator
      def initialize(config)
        validates [
          Rules::IssuerCorrect.new(config::ISSUER),
          Rules::LimitedRenewals.new(config::MAX_RENEWALS),
          Rules::NotUsableBefore.new,
          Rules::SubjectPresence.new,
          Rules::AudiencePresence.new,
          Rules::Expiration.new
        ]
      end
    end
  end
end
