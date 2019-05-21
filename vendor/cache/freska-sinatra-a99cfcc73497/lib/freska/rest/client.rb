module Freska
  module Rest
    class Client

      HTTP_VERBS = %i[get post put patch delete].freeze

      attr_accessor :logger, :authorizer, :adapter
      delegate :close, to: :adapter

      def initialize(url, default_headers, adapter_class = Adapters::Excon)
        @adapter = adapter_class.new url, default_headers
      end

      def get(path, body: {}, headers: {})
        call(:get, path, body: body, headers: headers)
      end

      def post(path, body: {}, headers: {})
        call(:post, path, body: body, headers: headers)
      end

      def patch(path, body: {}, headers: {})
        call(:patch, path, body: body, headers: headers)
      end

      def put(path, body: {}, headers: {})
        call(:put, path, body: body, headers: headers)
      end

      def delete(path, body: {}, headers: {})
        call(:delete, path, body: body, headers: headers)
      end

      def call(method, path, body: {}, headers: {})
        headers.merge!('AUTHORIZATION' => "Bearer #{authorizer.token}") if authorizer.present?

        response = adapter.call(method, path, body: body, headers: headers)
        if logger
          logger.info "#{method} #{path} >> status: #{response.status}"
          logger.debug "body: #{response.body}"
        end

        response
      end
    end
  end
end
