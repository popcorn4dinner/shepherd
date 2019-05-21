module Freska
  module Kafka
    module Encoders
      module Factory
        def self.create_for(name)
         case name.to_sym
         when :json
           Json.new
         when :avro
           raise Freska::ConfigurationError, "messaging: avro is not yet supported"
         else
           raise Freska::ConfigurationError, "messaging: invalid encoder configured"
         end
        end
      end
    end
  end
end
