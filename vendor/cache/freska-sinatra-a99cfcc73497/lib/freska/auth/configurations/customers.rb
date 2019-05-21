module Freska
  module Auth
    module Configurations
      module Customers
        LIFETIME = 20.minutes
        MAX_RENEWALS = 20
        RENEWAL_MARGIN = 10.minutes
        ISSUER = "auth.soa.customers".freeze
        AUDIENCE = 'freska.soa.customers'
        USER_TYPE = :customer
      end
    end
  end
end
