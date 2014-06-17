require 'rubygems'
require 'cgi'
require 'faraday'
require 'socket'

require 'elementary/future'

module Elementary
  module Transport
    class HTTP
      def initialize(hosts)
        @hosts = hosts
      end

      def call(service, rpc_method, *params)
        begin
          # MIDDLEWARE STACK TERMINATOR
          response = client.post do |h|
            path = "/#{CGI.escape(service.name)}/#{rpc_method.method}"
            h.url(path)
            h.body = params[0].encode
          end

          # XXX: Need to raise on failures?
          return rpc_method[:response_type].decode(response.body)
        rescue StandardError => e
          puts "UNHANDLED EXCEPTION #{e.inspect}"
          raise
        end
      end

      private

      def host_url
        # XXX: need to support a full collection of hosts similar to
        # elasticsearch-ruby
        host = @hosts.first
        return "http://#{host[:host]}:#{host[:port]}/"
      end

      def client
        return @client if @client

        @client = Faraday.new(:url => host_url) do |f|
          f.response :logger
          f.adapter :net_http_persistent
        end

        return @client
      end
    end
  end
end

