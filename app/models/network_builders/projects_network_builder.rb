module NetworkBuilders

  class ProjectsNetworkBuilder < BaseNetworkBuilder

      def initialize(projects, options={})
        @projects = projects
        @options = default_options.merge!(options)
      end

      def build()
        network = Vis::Network::Base.new(@options)

        network.add_node_type :user, get_vis_options_for(:user)
        network.add_node_type :service, get_vis_options_for(:service)
        network.add_node_type :resource, get_vis_options_for(:resource)
        network.add_node_type :project, get_vis_options_for(:project)

        network.add_edge_type :arrow, {arrows: 'to'}
        network.add_edge_type :line, {length: 70, smooth: false}


        @projects.each do |project|
          project_connections_for(project).each do |service|
            project_node = process_project network, service.project
            service_node = process_service network, service

            network.add_edge project_node, service_node, :line
          end
        end

        return network
      end

      private

      def project_connections_for(project)
        project.services.select do |s|
          s.external_dependencies.any? || s.is_user_entry_point || s.dependency_of.any?
        end
      end

      def project_options
        colors = [rand(50..220), rand(50..220), rand(50..220)]
        dark_colors = colors.map{|c| c - 30}

        return {
          color: {
              background: rgb_string_for(colors),
              border: rgb_string_for(dark_colors)
            }
        }
      end

      def rgb_string_for(colors)
        "rgb(" + colors.join(',') +")"
      end

      def process_project(network, project)
        group_name = group_name_for(project)
        network.find_or_create_node_group group_name, nil, project_options
        project_node = network.find_node_by_name project.name

        return project_node || network.add_node(project.name, :project, group_name)
      end

      def process_service(network, service)
        service_node = network.find_node_by_name service.name

        unless service_node.present?
          service_node = create_service_node network, service

          if service.is_user_entry_point
            user_node = network.add_node "User", :user
            network.add_edge user_node, service_node, :arrow
          end

          service.direct_external_dependencies.each do |dependency|
            dependency_node = process_service network, dependency
            network.add_edge service_node, dependency_node, :arrow
          end

          service.external_resources.each do |resource|
            resource_node = network.find_node_by_name resource.name
            unless resource_node.present?
              resource_node = network.add_node resource.name, :resource
            end

            network.add_edge service_node, resource_node, :arrow

          end
        end

        return service_node
      end

  end
end
