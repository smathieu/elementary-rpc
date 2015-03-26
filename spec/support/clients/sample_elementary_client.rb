require 'elementary'

class SampleElementaryClient < BaseElementaryClient
  def connection
    return @connection if @connection
    @connection = Elementary::Connection.new(Elementary::Rspec::Simple,
                                             :hosts => [{'host' => 'localhost', 'port' => '8080'}])
  end
end