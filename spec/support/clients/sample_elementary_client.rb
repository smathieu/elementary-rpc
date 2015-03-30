require 'elementary'

class SampleElementaryClient < BaseElementaryClient
  def initialize(port)
    @port = port
  end
  def connection
    return @connection if @connection
    @connection = Elementary::Connection.new(Elementary::Rspec::Simple,
                                             :hosts => [{'host' => 'localhost', 'port' => @port}])
  end
end