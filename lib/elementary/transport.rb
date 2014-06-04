require 'rubygems'
require 'cgi'
require 'faraday'
require 'socket'

require 'elementary/future'

module Elementary
  module Transport
    class HTTP
      def initialize(app)
        # swallw app, we should be at the bottom of the middleware stack
      end

      def call(service, rpc_method, *params)
        # MIDDLEWARE STACK TERMINATOR
        response = client.post do |h|
          path = "/#{CGI.escape(service.name)}/#{rpc_method.method}"
          h.url(path)
          h.body = params[0].encode
        end

        # XXX: Need to raise on failures?
        return rpc_method[:response_type].decode(response.body)
      end

      private

      def client
        Faraday.new(:url => 'http://localhost:8001/') do |f|
          f.response :logger
          f.adapter Faraday.default_adapter
        end
      end
    end
  end
end

