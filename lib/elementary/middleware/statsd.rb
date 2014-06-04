require 'rubygems'
require 'statsd'

module Elementary
  module Middleware
    class Statsd
      def initialize(app)
        @app = app
        # XXX: needs to be more configurable
        @statsd = ::Statsd::Client.new
      end

      def call(service, rpc_method, *params)
        @statsd.timing(metric_name(service.name, rpc_method.method)) do
          @app.call(service, rpc_method, *params)
        end
      end

      def metric_name(service_name, method_name)
        service_name = service_name.gsub('::', '.').downcase
        return "elementary.#{service_name}.#{method_name}"
      end
    end
  end
end
