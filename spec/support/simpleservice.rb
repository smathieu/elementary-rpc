require './spec/support/simpleservice.pb'

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
    end
  end
end

