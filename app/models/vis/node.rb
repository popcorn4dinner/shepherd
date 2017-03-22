module Vis
  module Network
    class Node
      attr_accessors :name, :group, :options
      attr_readers :id

      def initialize(name, type, group = nil, options = {})
        name = name
        group = group
        type = type
        options = options

        set_id
      end

      def to_hash
        result = {
          :id => id,
          :name => name
        }.merge(options)

        if group.present?
          result[:group] => group.name
        end

        return result
      end

      private

      def last_id
        @@ids || 0
      end

      def set_id
        @id = last_id +1
        last_id = id
      end

    end
  end
end
