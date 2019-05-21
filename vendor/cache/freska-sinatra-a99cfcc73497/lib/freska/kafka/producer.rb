require 'singleton'

# This is a wrapper around 'ruby-kafka' and it's producers.
# It's api is based on the the documented features here:
# https://github.com/zendesk/ruby-kafka#producing-messages-to-kafka

module Freska
  module Kafka
    class Producer
      include Singleton

      attr_accessor :kafka_client, :async_producer, :encoder

      def produce(message, topic:, key: nil, partition_key: nil, partition: nil, encoding_args: {})
        async_producer.produce(
          encoder.encode(message, encoding_args),
          topic: topic,
          key: key,
          partition_key: partition_key,
          partition: partition
        )
      end

      def deliver_message(message, topic:, key: nil, partition_key: nil, partition: nil, encoding_args: {})
        kafka_client.deliver_message(
          encoder.encode(message, encoding_args),
          topic: topic,
          key: key,
          partition_key: partition_key,
          partition: partition
        )
      end

      def configured?
        kafka_client.present?
      end

      def configure(kafka_client:, delivery_threshold:, delivery_interval:, encoder:)
        @kafka_client = kafka_client
        @async_producer = kafka_client.async_producer(
          delivery_threshold: delivery_threshold,
          delivery_interval: delivery_interval
        )
        @encoder = encoder
      end
    end
  end
end
