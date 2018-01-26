module Vis
  module Network

    class NodeGroup
      attr_accessor :name, :type

      def initialize(name, type, options)
        @name = name
        @type = type
        @options = options
      end

      def to_hash
        {name: name }.merge( @options )
      end

    end

  end
end
