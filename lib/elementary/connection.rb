require 'rubygems'
require 'protobuf'
require 'hashie'

require 'elementary/middleware'
require 'elementary/transport'

module Elementary
  class Connection
    attr_reader :raise_on_error, :service

    DEFAULT_HOSTS = [{:host => 'localhost', :port => 8000}].freeze

    # Initialize a connection to the +Protobuf::Rpc::Service+
    #
    # @param [Protobuf::Rpc::Service] service
    # @param [Hash] opts
    # @options opts [Symbol] :transport Defaults to :http, must map to a class
    #   in the +Elementary::Transport+ module
    # @options opts [Array] :hosts An array of {:host => 'localhost', :port =>
    #   8080} hashes to instruct the connection
    # @option opts [Hash] :transport_options A +Hash+ of request options that
    #   will be passed down to the transport layer. This will depend on what
    #   options are available by the underlying transport
    # @option opts [Hash] :future_options A +Hash+ of options to use when
    #   constructing the Concurrent::Future to run the RPC. In particular, it
    #   allows specifying the :executor for the Concurrent::Future.
    def initialize(service, opts={})
      opts = Hashie::Mash.new(opts)

      if service.nil? || service.superclass != Protobuf::Rpc::Service
        raise ArgumentError,
          "Cannot construct an Elementary::Connection with `#{service}` (#{service.class})"
      end

      @service = service
      @transport = opts[:transport]
      @hosts = opts[:hosts] || DEFAULT_HOSTS
      @transport_opts = opts[:transport_options] || {}
      @future_opts = opts[:future_options] || {}
      # Create exectutor here to avoid threading issues later. See Issue #43
      rpc
    end

    def rpc
      @rpc ||= Elementary::Executor.new(@service, select_transport, @future_opts)
    end

    def select_transport
      Elementary::Transport::HTTP.new(@hosts, @transport_opts)
    end
  end
end
