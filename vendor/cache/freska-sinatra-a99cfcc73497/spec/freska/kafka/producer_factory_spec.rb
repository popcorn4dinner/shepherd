require_relative '../../spec_helper'

RSpec.describe Freska::Kafka::ProducerFactory do

  describe "should return a kafka producer" do

    it "without ssl options" do
      settings = {
        messaging: {
          adapter: 'kafka',
          encoder: 'json',
          client_id: 'some-id',
          delivery_interval: 1,
          delivery_threshold: 10,
          host: 'somewhere.else',
          port: '12345'
        }
      }.to_dot
      result = Freska::Kafka::ProducerFactory.create(settings)

      expect(result).to be_a(Freska::Kafka::Producer)
    end
  end

  describe "should raise configuration error" do
    it "with not existing encoder" do
      settings = {
        messaging: {
          adapter: 'kafka',
          encoder: 'nonsense',
          client_id: 'some-id',
          delivery_interval: 1,
          delivery_threshold: 10,
          host: 'somewhere.else',
          port: '12345'
        }
      }.to_dot
      expect { Freska::Kafka::ProducerFactory.create(settings) }.to raise_error(Freska::ConfigurationError)
    end


    it "with missing encoder" do
      settings = {
        messaging: {
          adapter: 'kafka',
          client_id: 'some-id',
          delivery_interval: 1,
          delivery_threshold: 10,
          host: 'somewhere.else',
          port: '12345'
        }
      }.to_dot
      expect { Freska::Kafka::ProducerFactory.create(settings) }.to raise_error(Freska::ConfigurationError)
    end

    it "with missing host" do
      settings = {
        messaging: {
          adapter: 'kafka',
          encoder: 'json',
          client_id: 'some-id',
          delivery_interval: 1,
          delivery_threshold: 10,
          port: '12345'
        }
      }.to_dot
      expect { Freska::Kafka::ProducerFactory.create(settings) }.to raise_error(Freska::ConfigurationError)
    end

    it "with missing port" do
      settings = {
        messaging: {
          adapter: 'kafka',
          encoder: 'json',
          client_id: 'some-id',
          delivery_interval: 1,
          delivery_threshold: 10,
          host: 'some/where'
        }
      }.to_dot
      expect { Freska::Kafka::ProducerFactory.create(settings) }.to raise_error(Freska::ConfigurationError)
    end

    it "with missing client_id" do
      settings = {
        messaging: {
          adapter: 'kafka',
          encoder: 'json',
          delivery_interval: 1,
          delivery_threshold: 10,
          host: 'something',
          port: '12345'
        }
      }.to_dot
      expect { Freska::Kafka::ProducerFactory.create(settings) }.to raise_error(Freska::ConfigurationError)
    end







  end
end
