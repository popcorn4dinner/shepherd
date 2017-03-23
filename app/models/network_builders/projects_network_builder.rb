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

        network.add_edge_type :arrow, {arrows: 'to'}

        @projects.each do |project|
          network.add_node_type   {
              color: {
                  background: 'grey',
                  border: 'white'
                }
            }

          project_connections = project.services.select {|s| s.external_dependencies.any?}

          project_connections.each do |service|
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
            dependency_node = process_service network, dependency
            network.add_edge service_node, dependency_node, :arrow
          end
        end

        return service_node
      end

  end
end
