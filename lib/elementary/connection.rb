require 'rubygems'
require 'protobuf'


module Elementary
  class Connection
    attr_reader :raise_on_error, :service

    # Initialize a connection to the +Protobuf::Rpc::Service+
    #
    # @param [Protobuf::Rpc::Service] service
    # @param [Hash] opts
    # @options opts [Boolean] :raise_on_error Defaults to true, will cause
    #   rpc errors to raise exceptions
    def initialize(service, opts={})
      if service.nil? || service.superclass != Protobuf::Rpc::Service
        raise ArgumentError,
          "Cannot construct an Elementary::Connection with `#{service}` (#{service.class})"
      end

      @raise_on_error = opts[:raise_on_error] || true
      @service = service
    end
  end
end
