require 'async/http/internet'

module Freska
  module Rest
    module Adapters
      class Internet
        def initialize(url, default_headers = {}, client_class: ::Async::HTTP::Internet)
          @conn = client_class.new
          @base_url = url
          @default_headers = default_headers
        end

        def call(method, path, body: {}, headers: {})
          headers = transform_headers @default_headers.merge(headers)
          query = method == :get ? body.to_query : ''
          body = method == :get ? {} : body.to_json
          @conn.send(method, compose_url_for(path, query), headers, body.to_json)
        end

        def close
          @conn.close
        end

        private

        def response_for(original)
          Response.new headers: original.headers, body: original.read, status: original.status
        end

        def compose_url_for(path, query)
          url_parts = [@base_url, path]
          url_parts << "?=#{query}" unless query.empty?
          URI.join(*url_parts)
        end

        def transform_headers(headers)
          output = []
          headers.keys.each do |key|
            output << [[key.to_s, headers[key].to_s]]
          end
          output
        end
      end

    end
  end
end
