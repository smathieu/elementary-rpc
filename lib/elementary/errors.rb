module Elementary
  module Errors
    # A simple root class to signify an failure on the RPC server side (see
    #   "rpc_failed 'message'")
    class RPCFailure < StandardError; end;
  end
end
