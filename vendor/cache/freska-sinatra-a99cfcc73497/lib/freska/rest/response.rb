module Freska
  module Rest
    class Response
      attr_accessor :headers, :body, :status
      attr_writer :status

      def initialize(headers:, body:, status:)
        @headers = headers
        @body = body
        @status = status
      end

      def status
        @status.to_s
      end

      def ok?
        status[0].eql?('2')
      end

      def redirected?
        status[0].eql?('3')
      end

      def client_error?
        status[0].eql?('4')
      end

      def bad_request?
        status.eql?('400')
      end

      def server_error?
        status[0].eql?('5')
      end
    end
  end
end
