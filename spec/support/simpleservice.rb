require './spec/support/simpleservice.pb'
require 'protobuf/rpc/error'

module Elementary
  module Rspec
    class Simple
      def echo
        puts "ECHOING #{request.inspect}"
        sleep 1

        respond_with(String.new(:data => request.data))
      end

      def error
        rpc_failed 'sample failure'
      end

      def bad_request_data_method
        fail ::Protobuf::Rpc::BadRequestData, 'sample bad request data failure'
      end

      def service_not_found_method
        fail ::Protobuf::Rpc::ServiceNotFound, 'sample service not found failure'
      end
    end
  end
end

