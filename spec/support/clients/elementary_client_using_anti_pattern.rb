require 'elementary'

class ElementaryClientUsingAntiPattern < BaseElementaryClient
  # This class demonstrates an anti-pattern of creating connection
  # at initialization only. Although it works mostly, this pattern should not be used,
  # since the connection should be re-established any time the connection object becomes nil.

  def initialize
    @connection = Elementary::Connection.new(Elementary::Rspec::Simple,
                                             :hosts => [{'host' => 'localhost', 'port' => '8090'}])
  end
end

