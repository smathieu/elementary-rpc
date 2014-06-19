
module Elementary
  class Executor
    attr_reader :service, :transport

    def initialize(service, transport)
      @service = service
      @transport = transport
    end

    def method_missing(method_name, *params)
      rpc_method = service.rpcs[method_name.to_sym]
      # XXX: explode if rpc_method is nil

      future = Elementary::Future.new do
        # This is effectively a Rack middleware stack. yay.
        #
        # Easiest to think of it like this:
        #   Statsd.new(HTTP.new(nil))
        stack = Elementary.middleware.inject(transport) do |accumulator, middleware|
          klass = middleware.first
          options = middleware.last
          klass.new(accumulator, options)
        end

        stack.call(service, rpc_method, *params)
      end

      return future.execute
    end
  end
end
