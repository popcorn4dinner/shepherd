module Freska
  module Auth
    module Configurations
      module Machines
        LIFETIME = 1.hour
        MAX_RENEWALS = 24
        RENEWAL_MARGIN = 20.minutes
        ISSUER = "auth.soa.machines".freeze
        AUDIENCE = 'freska.soa.machines'
        USER_TYPE = :machine
      end
    end
  end
end
