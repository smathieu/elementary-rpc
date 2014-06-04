require 'rubygems'
require 'protobuf'

require 'elementary/middleware'
require 'elementary/transport'

module Elementary
  class Connection
    attr_reader :raise_on_error, :service

    # Initialize a connection to the +Protobuf::Rpc::Service+
    #
    # @param [Protobuf::Rpc::Service] service
    # @param [Hash] opts
    # @options opts [Symbol] :transport Defaults to :http, must map to a class
    #   in the +Elementary::Transport+ module
    # @options opts [Boolean] :raise_on_error Defaults to true, will cause
    #   rpc errors to raise exceptions
    # @optiosn opts [Array] :hosts An array of {:host => 'localhost', :port =>
    #   8080} hashes to instruct the connection
    def initialize(service, opts={})
      if service.nil? || service.superclass != Protobuf::Rpc::Service
        raise ArgumentError,
          "Cannot construct an Elementary::Connection with `#{service}` (#{service.class})"
      end

      @raise_on_error = opts[:raise_on_error] || true
      @service = service
      @transport = opts[:transport] || :http
    end

    def middleware
    end

    def rpc
      Executor.new(@service)
    end
  end

  class Executor
    attr_reader :service

    def initialize(service)
      @service = service
    end

    def middleware
      [
        Elementary::Transport::HTTP,
        Elementary::Middleware::Statsd,
      ]
    end

    def method_missing(method_name, *params)
      rpc_method = service.rpcs[method_name.to_sym]
      # XXX: explode if rpc_method is nil

      future = Elementary::Future.new do
        # This is effectively a Rack middleware stack. yay.
        #
        # Easiest to think of it like this:
        #   Statsd.new(HTTP.new(nil))
        stack = middleware.inject(nil) do |accumulator, ware|
          ware.new(accumulator)
        end

        stack.call(service, rpc_method, *params)
      end

      return future.execute
    end
  end
end
