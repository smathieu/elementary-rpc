##
# This file is auto-generated. DO NOT EDIT!
#
require 'protobuf/message'
require 'protobuf/rpc/service'

module Elementary
  module Rspec

    ##
    # Message Classes
    #
    class String < ::Protobuf::Message; end


    ##
    # Message Fields
    #
    class String
      required :string, :data, 1
      optional :int64, :status, 2
    end


    ##
    # Service Classes
    #
    class Simple < ::Protobuf::Rpc::Service
      rpc :echo, ::Elementary::Rspec::String, ::Elementary::Rspec::String
    end

  end

end

