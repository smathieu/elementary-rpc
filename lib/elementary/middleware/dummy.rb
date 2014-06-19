module Elementary
  module Middleware
    class Dummy
      def initialize(app, opts={})
        @app = app
        @opts = opts
      end

      def call(service, rpc_method, *params)
        puts "#{self.class.name}#call (options: #{@opts}"
        @app.call(service, rpc_method, *params)
      end
    end
  end
end
