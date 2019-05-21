require 'kafka'

module Freska
  module Kafka
    class ProducerFactory
      SSL_CONFIG_KEYS = %i[ssl_ca_cert ssl_client_cert ssl_client_cert_key].freeze

      MAX_QUEUE_SIZE = 1_000 # 1k messages
      MAX_BUFFER_SIZE = 100_000_00 # 10MB

      class_attribute :producer

      class << self
        def create(settings)
          raise_config_error 'messaging is not configured' if settings.messaging.empty?
          producer.present? ? producer : configure_producer_with(settings.messaging)
        end

        private

        def configure_producer_with(settings)
          producer = Producer.instance

          raise_config_error "no encoder configured" unless settings.respond_to? :encoder
          raise_config_error "delivery_interval missing" unless settings.respond_to? :delivery_interval
          raise_config_error "delivery_threshold missing" unless settings.respond_to? :delivery_threshold

          producer.configure(
            kafka_client: kafka_client_for(settings),
            delivery_interval: settings.delivery_interval,
            delivery_threshold: settings.delivery_threshold,
            encoder: Encoders::Factory.create_for(settings.encoder)
          )

          producer
        end

        def raise_config_error(message)
          raise Freska::ConfigurationError, message
        end

        def kafka_client_for(settings)
          unless settings.respond_to?(:host) && settings.respond_to?(:port)
            raise_config_error 'messaging: host and port not configured'
          end

          raise_config_error 'messaging: client_id missing' unless settings.respond_to?(:client_id)

          ssl_args = {}
          SSL_CONFIG_KEYS.each do |key|
            ssl_args[key] = File.read(settings[key]) if settings.key?(key)
          end

          ::Kafka.new(
            ["#{settings.host}:#{settings.port}"],
            client_id: settings.client_id,
            **ssl_args
          )
        end
      end
    end
  end
end
