require_relative './api_controller'

module Freska
  class HealthController < ApiController

    before do
      content_type :json
    end

    get '/health' do
      status 200
    end

    get '/info' do
      if settings.framework.expose_info_endpoint
        {
          name: settings.app.name,
          version: SERVICE_VERSION,
          environment: settings.environment,
          config: settings.all
        }.to_json
      else
        status 403
      end
    end
  end
end
