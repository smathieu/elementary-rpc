require 'rubygems'
require 'concurrent'

module Elementary
  class Future < Concurrent::Future
    # Invoke undefined methods on the value of the future
    #
    # E.g.
    #   results = c.rpc.search(query)
    #   # sleep maxint
    #   results.each do |result|
    #     # work
    #   end
    # 
    # Which would really invoke:
    #   results.value.each
    def method_missing(method, *params)
      puts "missing! #{method}"
      self.value.send(method, *params)
    end

    def value
      return super unless Elementary.synchronous?
      return @value
    end

    def execute
      # If we're going to be async, we'll let +Concurrent::Future+ handle the
      # task
      return super unless Elementary.synchronous?

      # Set our value (refer to Concurrent::Deferenceable for #value=
      self.value = @task.call

      return self
    end
  end
end
