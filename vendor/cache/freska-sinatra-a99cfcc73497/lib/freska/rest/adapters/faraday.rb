require 'faraday'

module Freska
  module Rest
    module Adapters
      class Faraday

        CONTENT_TYPE_HEADER = {'Content-Type' => 'application/x-www-form-urlencoded'}

        def initialize(url, default_headers = {}, client_class: ::Faraday)
          @conn = client_class.new url: url
          @default_headers = default_headers
        end

        def call(method, path, body: {}, headers: {})
          case method
          when :get
            response_for @conn.get path, body, @default_headers.merge(headers)
          when :post, :put, :patch
            response_for @conn.send(
              method,
              path,
              body,
              CONTENT_TYPE_HEADER.merge(@default_headers).merge(headers)
            )
          when :delete
            response_for @conn.delete path, @default_headers.merge(headers)
          end
        end

        private

        def response_for(original)
          Response.new headers: original.headers, body: parse_response_body(original.body), status: original.status
        end

        def parse_response_body(body)
          JSON.parse body
        rescue JSON::ParserError
          body
        end

      end
    end
  end
end
