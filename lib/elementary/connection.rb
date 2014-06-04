require 'rubygems'
require 'protobuf'


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

    def rpc
      Elementary::Transport::HTTP.new(@service)
    end
  end
end
