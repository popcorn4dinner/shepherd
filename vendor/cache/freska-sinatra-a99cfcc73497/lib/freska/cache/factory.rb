require 'memcached'

module Freska
  module Cache
    class Factory
      CACHE_CONFIG_KEY = :cache
      DEFAULT_PORT = '11211'

      class_attribute :cache

      class << self

        def create(settings)
          verify_settings! settings
          config = settings.send(CACHE_CONFIG_KEY)

          case config.location
          when 'sidecar'
            cache ||= Memcached.new 'localhost:' + (config['port'] || DEFAULT_PORT)
            cache.clone
          else
            cache ||= Memcached.new config.location + ':' + (config['port'] || DEFAULT_PORT)
            cache.clone
          end
        end

        private

        def verify_settings!(settings)
          ok = settings.respond_to?(CACHE_CONFIG_KEY) && settings.send(CACHE_CONFIG_KEY).respond_to?(:location)
          raise_config_error('cache is not configured correctly') unless ok

          ok
        end

        def raise_config_error(message)
          raise Freska::ConfigurationError, message
        end

      end
    end
  end
end
