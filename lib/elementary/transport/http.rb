require 'rubygems'
require 'cgi'
require 'faraday'
require 'socket'

require 'elementary/errors'
require 'elementary/future'

module Elementary
  module Transport
    class HTTP
      ERROR_HEADER_MSG = 'x-protobuf-error'
      ERROR_HEADER_CODE = 'x-protobuf-error-reason'

      def initialize(hosts)
        @hosts = hosts
      end

      def call(service, rpc_method, *params)
        begin
          response = client.post do |h|
            path = "#{CGI.escape(service.name)}/#{rpc_method.method}"
            h.url(path)
            h.body = params[0].encode
          end

          error_msg = response.headers[ERROR_HEADER_MSG]
          error_code = response.headers[ERROR_HEADER_CODE]

          if error_msg
            raise Elementary::Errors::RPCFailure, "Error #{error_code}: #{error_msg}"
          end

          return rpc_method[:response_type].decode(response.body)
        rescue StandardError => e
          puts "EXCEPTION #{e.inspect}"
          raise
        end
      end

      private

      def host_url
        # XXX: need to support a full collection of hosts similar to
        # elasticsearch-ruby
        host = @hosts.first
        prefix = host[:prefix]
        return "http://#{host[:host]}:#{host[:port]}/#{prefix}"
      end

      def client
        return @client if @client

        @client = Faraday.new(:url => host_url) do |f|
          f.response :logger
          if Elementary.synchronous?
            f.adapter Faraday.default_adapter
          else
            f.adapter :net_http_persistent
          end
        end

        return @client
      end
    end
  end
end

