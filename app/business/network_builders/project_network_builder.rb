module NetworkBuilders
  class ProjectNetworkBuilder < BaseNetworkBuilder

        def initialize(project, options={})
          @project = project
          @options = default_options.merge!(options)
        end

        def build()
          network = Vis::Network::Base.new(@options)

          network.add_node_type :user, get_vis_options_for(:user)
          network.add_node_type :service, get_vis_options_for(:service)
          network.add_node_type :external_service, get_vis_options_for(:external_service)
          network.add_node_type :resource, get_vis_options_for(:resource)

          network.add_edge_type :arrow, {arrows: 'to'}

          @project.services.each do |service|
            process_service network, service
          end

          return network
        end

        private

        def process_service(network, service)
          service_node = network.find_node_by_name service.name

          unless service_node.present?
            service_type = service.project.eql?(@project) ? :service : :external_service
            service_node = create_service_node network, service, service_type

            if service.is_user_entry_point
              user_node = network.add_node "User", :user
              network.add_edge user_node, service_node, :arrow
            end

            service.dependencies.each do |dependency|
              dependency_node = process_service network, dependency
              network.add_edge service_node, dependency_node, :arrow
            end

            service.external_resources.each do |resource|
              process_resource network, service_node, resource
            end
          end

          return service_node
        end

  end
end
