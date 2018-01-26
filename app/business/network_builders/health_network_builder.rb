module NetworkBuilders
  class HealthNetworkBuilder < BaseNetworkBuilder

        def initialize(project, options={})
          @project = project
          @options = default_options.merge!(options)
        end

        def build()
          network = Vis::Network::Base.new(@options)

          network.add_node_type :user, get_vis_options_for(:user)

          network.add_node_type :up, get_vis_options_for(:service_up)
          network.add_node_type :config_error, get_vis_options_for(:service_warning)
          network.add_node_type :down, get_vis_options_for(:service_down)
          network.add_node_type :no_status, get_vis_options_for(:service)
          network.add_node_type :service, get_vis_options_for(:service)

          network.add_node_type :resource, get_vis_options_for(:resource)

          network.add_edge_type :arrow, {arrows: 'to'}
          network.add_edge_type :arrow_from, {arrows: 'from'}

          @project.services.each do |service|
            process_service network, service
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

            service.dependency_of.each do |dependency|
              dependency_node = process_service network, dependency
              network.add_edge service_node, dependency_node, :arrow_from
            end

            service.external_resources.each do |resource|
              process_resource network, service_node, resource
            end
          end

          return service_node
        end

        def create_service_node(network, service)
          return network.add_node service.name, service.status, group_name_for(service.project)
        end

        def get_vis_options_for(group_type)
          case group_type
            when :service
              {
                shape: 'dot'
              }
            when :service_up
              {
                color: {
                    background: '#0E8044',
                    border: '#0e5f34'
                  }
              }
            when :service_warning
              {
                color: {
                    background: '#e29b20',
                    border: '#a06e16'
                  }
              }
            when :service_down
              {
                color: {
                    background: '#E14658',
                    border: '#af3644'
                  }
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
            when :resource
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
end
