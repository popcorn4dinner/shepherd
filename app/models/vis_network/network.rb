class Network

  def initialize(projects)
    projects = projects.respond_to?(:each) ? projects : [projects]

    projects.each do |project|
      project.services.each do |service|
        process_service service
      end
    end
  end

  def nodes
    @nodes ||= []
  end

  def edges
    @edges ||= []
  end

  def groups
    @groups ||= {}
  end

  def to_hash
    {
      nodes: nodes,
      edges: edges,
      groups: groups,
      options: options
    }
  end

  def options
    {
      nodes: {
            shape: 'dot',
            size: 20,
            font: {
                size: 15,
                color: '#ffffff'
            },
            borderWidth: 5
        },
      edges: {
            width: 3
        },
      groups: groups
      }
  end



  private

  def process_service(service)
    service_node = find_node_for service

    if service_node.nil?
      service_node = create_service_node service

      if service.is_user_entry_point
        user_group = find_or_create_group_by 'users', :user
        user_node = find_or_create_node_by "User", user_group, false
        add_edge_for user_node, service_node
      end

      service.dependencies.each do |dependency|
        dependency_node = process_service dependency
        add_edge_for service_node, dependency_node
      end

      group = find_or_create_group_by 'external_resource', :external_resource
      service.external_resources.each do |resource|
        node = find_or_create_node_by(resource.name, group)
        add_edge_for service_node, node
      end
    end

    return service_node
  end


  def add_edge_for(service, dependency)
    unless edge_exists_with? service, dependency
      edges << {from: service[:id], to: dependency[:id], arrows: 'to'}
    end
  end

  def edge_exists_with?(service, dependency)
    edge = edges.find {|e| e[:from] == service[:id] && e[:to] == dependency[:id]}
    edge.present?
  end

  def create_service_node(service)
    group = find_or_create_group_by service.project.name, :service
    return find_or_create_node_by service.name, group
  end

  def find_or_create_group_by(name, type)
    group = find_group_by name

    if group.nil?
      options = get_vis_options_for type
      group_name = group_name_for(name)
      group = {name: group_name }.merge( options )
      groups[group_name] = group
    end

    return group
  end

  def find_node_for(service)
    group_name = group_name_for(service.project.name)
    nodes.find  {|n| n[:label].eql?(service.name) && n[:group].eql?(group_name)}
  end

  def find_group_by(project_name)
    group_name = group_name_for(project_name)
    groups.key?(group_name) ? groups[group_name] : nil
  end

  def group_name_for(project_name)
    project_name.parameterize.gsub('-', '_')
  end

  def find_or_create_node_by(label, group, is_unique = true)
    node = nodes.find  {|n| n[:label].eql?(label) && n[:group].eql?(group[:name])}

    if node.nil? || !is_unique
      id = nodes.count+1
      node = {id: id, label: label, group: group[:name]}
      nodes << node
    end

    return node
  end

  def get_vis_options_for(group_type)
    case group_type
      when :service
        {
          shape: 'dot'
        }
      when :user
        {
          shape: 'icon',
          icon: {
              face: 'FontAwesome',
              code: "\uf0c0",
              size: 50,
              color: 'orange'
          }
        }
      when :external_resource
        {
          shape: 'triangle',
          color: {
              background: 'grey',
              border: 'white'
            }
        }
      else
        raise ArgumentError, "Invalid group type", caller
    end
  end

end
