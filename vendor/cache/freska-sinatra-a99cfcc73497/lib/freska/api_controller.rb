require "yaml"
require "hash_dot"
require "sinatra/base"
require "sinatra/param"
require 'rack/contrib'

module Freska
  class ApiController < ::Sinatra::Application

    include Onion::CommandExecuter
    use Rack::PostBodyContentTypeParser
    helpers ::Sinatra::Param

    set(:config) do
      config_template = ERB.new File.read "config/#{ENV['APP_ENV']}.yaml"
      YAML.safe_load(config_template.result(binding)).to_dot
    end

    configure do
      set :show_exceptions, config.framework.show_pretty_errors
      set :app, config.app
      set :framework, config.framework
      set :messaging, (config.respond_to?(:messageing) ? config.messaging : {}.to_dot)
      set :communication, (config.respond_to?(:communication) ? config.communication : {}.to_dot)
      set :cache, (config.respond_to?(:cache) ? config.cache : {}.to_dot)
      set :firestore, (config.respond_to?(:firestore) ? config.firestore : {}.to_dot)
      set :all, config
      set :raise_error, false
      set :server, :puma
      set :root, File.dirname(__FILE__)
      enable :raise_sinatra_param_exceptions
      disable :sessions
    end

    before do
      content_type :json
    end

    error Sinatra::Param::InvalidParameterError do
      status 400
      {
        errors: [:invalid_parameter_error],
        parameter: raised_error.param,
        messages: ["#{raised_error.param} is invalid"]
      }.to_json
    end

    error Auth::AuthorizationError do
      status 403
      raised_error.to_json
    end

    error ::RuntimeError do
      status 500
      if raised_error.respond_to?(:to_json)
        raised_error.to_json
      else
        default_error_message
      end
    end

    private

    def default_error_message
      "Oops, something went wrong"
    end

    def raised_error
      env['sinatra.error']
    end

    def logger_for(settings)
      @logger ||= LoggerFactory.create_for(settings)
    end

    def current_user
      request.env['app.current_user']
    end
  end
end
