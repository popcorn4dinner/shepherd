module Vis
  module Network

    class NodeGroup
      attr_accessors :name, :type, :options

      def initialize(name, type, options)
        name = name
        type = type
        options = options
      end

      def to_hash
        {name: group_name }.merge( options )
      end

    end

  end
end
