require 'rubygems'
require 'statsd'

module Elementary
  module Middleware
    class Statsd
      # Create a new Statsd middleware for Elementary
      #
      # @param [Hash] opts Hash of optional parameters
      # @option opts [::Statsd::Client] :client Set to an existing instance of
      # a +Statsd::Client+
      def initialize(app, opts={})
        @app = app

        @statsd = opts[:client] || ::Statsd::Client.new
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
