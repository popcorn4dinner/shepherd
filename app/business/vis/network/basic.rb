module Vis
  module Network
    class Basic

      attr_reader :nodes, :edges, :groups

      def initialize(options)
        @options = options
        @nodes = []
        @edges = []
        @groups = []
        @node_types = {}
        @edge_types = {}
      end

      def to_hash
        {
          nodes: prepare_parts_for(:node, nodes),
          edges: prepare_parts_for(:edge, edges),
          groups: prepare_parts_for(:node, groups),
          options: options
        }
      end

      def options
        prepared_groups = {}
        prepare_parts_for(:node, groups).each do |group|
          prepared_groups[group[:name]] = group
        end

        @options.merge!({groups: prepared_groups})
      end

      def add_node_type(name, options)
        add_type_for @node_types, name, options
      end

      def add_edge_type(name, options)
        add_type_for @edge_types, name, options
      end

      def find_or_create_node_group(name, type, options = {})
        group = groups.detect { |g| g.name.eql? name }

        unless group.present?
          group = create_node_group name, type, options
        end

        return group
      end

      def create_node_group(name, type, options = {})
        if type.present? && !type_exists_for?(:node, type)
          raise ArgumentError, "Type #{type} does not exist.", caller
        end

        group = Network::NodeGroup.new name, type, options
        groups << group

        return group
      end

      def add_node(name, type = nil, group_name = nil, options = {})
        unless group_name.nil?
          group = find_or_create_node_group(group_name, :service)
        end

        if type.present? && !type_exists_for?(:node, type)
          raise ArgumentError, "Type #{type} does not exist.", caller
        else
          node = Network::Node.new name, type, group, options
          nodes << node
        end

        return node
      end

      def add_edge(from, to, type = nil, options = {})
        if edge_exists_with? from, to
        elsif type.present? && !type_exists_for?(:edge, type)
          raise ArgumentError, "Type #{type} does not exist.", caller
        else
          edge = Network::Edge.new from, to, type, options
          edges << edge
        end

        return edge
      end

      def find_node_by_name(name)
        nodes.detect {|n| n.name.eql? name}
      end

      private

      def add_type_for(container, name, options)
        name = name.to_sym
        unless container.key? name
          container[name] = options
        else
          raise ArgumentError, "Type #{name} already exists.", caller
        end
      end

      def type_exists_for?(scope, name)
        get_option_container_for(scope).key? name.to_sym
      end

      def edge_exists_with?(service, dependency)
        edges.any? {|e| e.from == service && e.to == dependency}
      end

      def get_options_for(scope, name)
        container = get_option_container_for(scope)
        return container.key?(name.to_sym) ? container[name.to_sym] : {}
      end

      def get_option_container_for(scope)
        if scope.eql? :node
          @node_types
        else
          @edge_types
        end
      end

      def prepare_parts_for(type, parts)
        parts.map do |part|
          options = get_options_for type, part.type
          options.merge(part.to_hash)
        end
      end

    end
  end
end
