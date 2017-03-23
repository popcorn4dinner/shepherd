module NetworkBuilders

  class ProjectsNetworkBuilder < BaseNetworkBuilder

      def initialize(project, options)
        @project = project
        @options = default_options.merge!(options)
      end

      def build()
        network = Vis::Network.new(options)

        network.add_node_type :user, get_vis_options_for(:user)
        network.add_node_type :service, get_vis_options_for(:service)
        network.add_node_type :resource, get_vis_options_for(:resource)

        network.add_edge_type :service, {arrow: 'to'}

        @projects.each do |project|
          project.services.each do |service|
            process_service network, service
          end
        end

        return network
      end

      private

      def process_service(network, service)
        service_node = network.find_node_by_name service.name

        unless service_node.present?
          service_node = create_service_node network, service

          if service.is_user_entry_point
            user_node = network.add_node "User", :user
            network.add_edge user_node, service_node, :arrow
          end

          service.external_dependencies.each do |dependency|
            dependency_node = process_service dependency
            add_edge_for service_node, dependency_node
          end
        end

        return service_node
      end

  end
end
