require 'google/cloud/firestore'

module Freska
  module Firestore
    class Factory
      CONFIG_KEY = :firestore
      PROJECT_KEY = :project

      class << self
        class_attribute :client

        def create(settings)
          verify_settings! settings
          Google::Cloud::Firestore.new project_id: settings.send(CONFIG_KEY).send(PROJECT_KEY)
        end

        private

        def verify_settings!(settings)
          ok = settings.respond_to?(CONFIG_KEY) && settings.send(CONFIG_KEY).respond_to?(PROJECT_KEY)
          raise_config_error('firestore is not configured correctly') unless ok

          ok
        end

        def raise_config_error(message)
          raise Freska::ConfigurationError, message
        end

      end
   end
  end
end
