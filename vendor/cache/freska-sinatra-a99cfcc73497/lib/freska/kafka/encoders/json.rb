require 'json'

module Freska
  module Kafka
    module Encoders
      class Json
        attr_accessor :json_encoder

        def initialize(json_encoder = JSON)
          @json_encoder = json_encoder
        end

        def encode(payload, _options = {})
          json_encoder.generate(payload)
        end

        def decode(payload, _options = {})
          json_encoder.parse(payload)
        end
      end
    end
  end
end
