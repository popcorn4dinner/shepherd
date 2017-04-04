module NetworkBuilders

  class BaseNetworkBuilder

      def initialize
        raise "This shouldn't be initialized."
      end

      private

      def create_service_node(network, service, type = :service)
        return network.add_node service.name, type, group_name_for(service.project)
      end

      def process_resource(network, service_node, resource)
        node = network.find_node_by_name resource.name
        unless node.present?
          node = network.add_node resource.name, :resource
        end

        network.add_edge service_node, node, :arrow
      end

      def group_name_for(resource)
        resource.name.parameterize.gsub('-', '_')
      end

      def get_vis_options_for(group_type)
        case group_type
        when :external_service
            {
              shape: 'dot',
              color: {
                  background: 'light-grey',
                  border: 'grey'
                }
            }
          when :service
            {
              shape: 'dot'
            }
          when :project
            {
              size: 30
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
            }
          }
      end

  end
end
