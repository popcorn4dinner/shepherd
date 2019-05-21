module Onion
  module Agreement

    def implement_this!
      calling_method = caller_locations(1, 1)[0].label
      raise NotImplementedException.new(self.class.name, calling_method)
    end

    class NotImplementedException < ::StandardError

      def initialize(klass, method)
        @klass = klass
        @method = method
      end

      def message
        "#{@klass} has to implement :#{@method}}"
      end

      def to_s
        message
      end

    end
  end
end
