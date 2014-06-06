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
      self.value.send(method, *params)
    end
  end
end
