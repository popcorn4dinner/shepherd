module Freska
  module Auth
    module Rules
      class NotBlacklisted < Enforcer::Rule

        def initialize(blacklist, skip: [])
          @blacklist = blacklist
          super(skip: skip)
        end

        protected

        def violated_with?(subject)
          @blacklist.include? subject[:jti]
        end

        def error_message
          "token is blacklisted"
        end

      end
    end
  end
end
