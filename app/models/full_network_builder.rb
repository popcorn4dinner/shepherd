class FullNetworkBuilder


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

        project.services.each do |service|
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

          service.dependencies.each do |dependency|
            dependency_node = process_service dependency
            add_edge_for service_node, dependency_node
          end

          service.external_resources.each do |resource|
            process_resource network, service_node, resource
          end
        end

        return service_node
      end

      def create_service_node(network, service)
        return network.add_node service.name, :service, group_name_for(service)
      end

      def process_resource(network, service_node, resource)
        node = network.find_node_by_name resource.name
        unless node.present?
          node = network.add_node resource.name, :resource
        end

        network.add_edge service_node, node
      end

      def group_name_for(service)
        service.project.name.parameterize.gsub('-', '_')
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

      def default_options
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


    end
  end

end
