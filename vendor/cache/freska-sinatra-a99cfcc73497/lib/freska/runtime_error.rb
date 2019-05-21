module Freska
  class RuntimeError < ::RuntimeError

    def to_json
      {
        errors:    [error_name],
        messages:   [message],
        timestamp: Time.now.utc
      }.to_json
    end

    private

    def error_name
      class_name = self.class.name.split('::').last(1).join('_')
      class_name.gsub!(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      class_name.gsub!(/([a-z\d])([A-Z])/, '\1_\2')
      class_name.downcase!
      class_name
    end

  end
end
