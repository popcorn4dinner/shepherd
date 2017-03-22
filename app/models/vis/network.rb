module Vis
  class Network

    attr_readers :nodes, :edges, :groups

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
      @options.merge! {groups: prepare_parts_for(:node, groups)}
    end

    def add_node_type(name, options)
      add_type_for @node_types, name, options
    end

    def add_edge_type(name, options)
      add_type_for @edge_types, name, options
    end

    def find_or_create_node_group(name, type, options)
      group = groups.detect { |group| group.name.eql? name }
      unless group.present?
        if type.present? && !type_exists_for(:node, type)
          raise ArgumentError, "Type #{type} does not exist.", caller
        else
          group = Network::NodeGroup.new name, type, options
          groups << group
        end
      end

      return group
    end

    def add_node(name, type, group_name, options)
      if group.present?
        group = find_or_create_node_group(name, :service)
      end

      if type.present? && !type_exists_for(:node, type)
        raise ArgumentError, "Type #{type} does not exist.", caller
      else
        node = Network::Node.new name, type, group, options
        nodes << node
      end

      return node
    end

    def add_edge(from, to, type, options)
      if edge_exists_with? from, to
      elsif type.present? && !type_exists_for(:edge, type)
        raise ArgumentError, "Type #{type} does not exist.", caller
      else
        edge = Network::Edge.new from, to, type, options
        edges << {from: service[:id], to: dependency[:id], arrows: 'to'}
      end

      return edge
    end

    def find_node_by_name(name)
      nodes.detect {|n| n.name.eql? name}
    end

    private

    def add_type_for(container, name, options)
      unless container.key? name
        container[name] = options
      else
        raise ArgumentError, "Type #{name} already exists.", caller
      end
    end

    def type_exists_for?(scope, name)
      get_option_container_for(scope).key? name
    end

    def edge_exists_with?(service, dependency)
      edges.any? {|e| e.from == service && e.to == dependency}
    end

    def get_options_for(scope, name)
      container = get_option_container_for(scope)
      return container.key?(name) ? container[name] : {}
    end

    def get_option_container_for(scope)
      scope.eql? :node ? @node_types : @edge_types
    end

    def prepare_parts_for(type, parts)
      parts.map do |part|
        options = get_options_for type, part.type

        return options.merge! part.to_hash
      end
    end

  end
end
