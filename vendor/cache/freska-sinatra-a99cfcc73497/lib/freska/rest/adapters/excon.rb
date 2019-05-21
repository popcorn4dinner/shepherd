require 'excon'
require 'json'

module Freska
  module Rest
    module Adapters
      class Excon

        CONTENT_TYPE_HEADER = {'Content-Type' => 'application/x-www-form-urlencoded'}

        def initialize(url, default_headers = {}, client_class: ::Excon)
          @conn = client_class.new url, :persistnet => true
          @default_headers = default_headers
        end

        def call(method, path, body: {}, headers: {})
          case method
          when :get
            response_for @conn.get path: path, query: body, headers: @default_headers.merge(headers)
          when :post, :put, :patch
            response_for @conn.send(
              method,
              {
                path: path,
                body: URI.encode_www_form(body),
                headers: CONTENT_TYPE_HEADER.merge(@default_headers).merge(headers)
              }
            )
          when :delete
            response_for @conn.delete path, headers: @default_headers.merge(headers)
          end
        end

        def close
          @conn.close
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
