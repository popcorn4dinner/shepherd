module Freska
  module Rest
    class ClientFactory
      DEFAULT_PORT = '9292'
      DEFAULT_HTTPS_PORT = '443'
      DEFAULT_HTTP_VERSION = '1'
      USE_HTTPS_BY_DEFAULT = false

      def initialize(settings, logger = nil)
        verify_rest_communication_settings! settings
        @settings = settings
        @communication_config = settings.communication
        @logger = logger || Freska::LoggerFactory.create_for(settings)
      end

      def client_for(name)
        name = name.to_s
        raise Freska::ConfigurationError, "communication: #{name} not found." unless @communication_config.key?(name)

        config = @communication_config[name]
        raise Freska::ConfigurationError, "No url given for rest client" unless config.key?('url')

        port = config.key?('port') ? config['port'] : default_port_for(config['https'])
        url = compose_url_with config['url'], port, use_https: config['https']
        http_version = config.key?('http_version') ? config['http_version'] : DEFAULT_HTTP_VERSION
        default_headers = config.key?('default_headers') ? config['default_headers'] : {}

        client = Client.new(url, default_headers, adapter_for(version: http_version)).tap do |c|
          if config.key? 'auto_auth'
            c.authorizer = auth_factory.create_machine_authorizer
            puts "should be set"
          end
          c.logger = @logger
        end

        client
      end

      private

      def auth_factory
        @auth_factory ||= Auth::Factory.new @settings, self
      end

      def config_for(name)
        if @communication_config.key?(name)
          @communication_config = config.app.rest_communication
        else
          raise ConfigurationError, "No rest communication target configured for '#{name}'"
        end
      end

      def adapter_for(version:)
        case version
        when '1'
          Adapters::Faraday
        when '2'
          Adapters::Internet
        else
          raise Freska::ConfigurationError, "Invalid http version for configuration for rest client"
        end
      end

      def compose_url_with(url, port, use_https: USE_HTTPS_BY_DEFAULT)
        protocol = use_https ? 'https' : 'http'
        "#{protocol}://#{url}:#{port}"
      end

      def default_port_for(use_https = USE_HTTPS_BY_DEFAULT)
        use_https ? DEFAULT_HTTPS_PORT : DEFAULT_PORT
      end

      def verify_rest_communication_settings!(config)
        raise Freska::ConfigurationError, 'Rest communication is not configured for your service' unless config.respond_to?(:communication)
      end
    end
  end
end
