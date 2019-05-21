module Onion
  module CommandExecuter

    protected

    def execute(command_handler, with: {}, uses: [])
      handler_instance = handler_instance_for command_handler, uses
      handler_instance.execute( **white_listed_params_for(handler_instance, with) )
    end

    private

    def symbolize_param_keys(params)
      output = {}
      params.keys.each do |key|
        output[key.to_sym] = params[key]
      end

      output
    end

    def white_listed_params_for(handler_instance, params)
      allowed_params = handler_instance.command_params
      symbolize_param_keys(params).select { |p, _| allowed_params.include?(p)}
    end

    def handler_instance_for(command_handler, dependencies)
      if command_handler.is_a?(Class)
        create_handler_with command_handler, dependencies
      else
        command_handler
      end
    end

    def create_handler_with(command_handler, dependencies)
      handler_instance = command_handler.new(*dependencies)
      handler_instance.logger = logger_for(settings)

      handler_instance
    end

  end
end
