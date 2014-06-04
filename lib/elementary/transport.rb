require 'rubygems'
require 'cgi'
require 'faraday'
require 'socket'

require 'elementary/future'

module Elementary
  module Transport
    class HTTP
      def initialize(service)
        @service = service
      end

      def method_missing(name, *params)
        rpc_method = @service.rpcs[name.to_sym]

        # XXX: explode if rpc_method is nil

        future = Elementary::Future.new do
          response = client.post do |h|
            path = "/#{CGI.escape(@service.name)}/#{name}"
            h.url(path)
            h.body = params[0].encode
          end

          rpc_method[:response_type].decode(response.body)
        end

        return future.execute
      end

      def client
        Faraday.new(:url => 'http://localhost:8001/') do |f|
          f.response :logger
          f.adapter Faraday.default_adapter
        end
      end
    end
  end
end

