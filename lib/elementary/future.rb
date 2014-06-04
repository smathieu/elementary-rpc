require 'rubygems'
require 'concurrent'

module Elementary
  class Future < Concurrent::Future
    # TODO: Implement method_missing such that any method not defined on
    # Concurrent::Future will cause the future to be resolved and the method to
    # be called on the resulting value.
    #
    # This would make things like:
    #
    #   results = c.rpc.search(query)
    #   # sleep maxint
    #   results.each do |result|
    #     # work
    #   end
    # 
  end
end
