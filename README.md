# Elementary RPC

Elementary RPC is a basic
[Protobuf](https://developers.google.com/protocol-buffers/docs/overview) HTTP
RPC gem which aims to provide:

 * Easy RPC usage
 * Parallelism by default
 * An easily extended RPC request pipeline

### Sample Usage

For the following Protobuf RPC service definition:

```
package echoserv;

message String {
  required string data  = 1;
  optional int64 status = 2;
}

service Simple {
  rpc Echo (String) returns (String);
  rpc Reverse (String) returns (String);
}
```

A corresponding Ruby client might look something like this:

```ruby
require 'rubygems'
require 'elementary'

require 'echoserv/service.pb' # Include our protobuf object declarations


hosts = [{:host => 'localhost', :port => '9292', :prefix => '/rpcserv'}]


# Let's use the Statsd middleware to send RPC timing and count information to 
# Graphite (this presumes we have already used `Statsd.create_instance` elsewhere
# in our code)
Elementary.use(Elementary::Middleware::Statsd, :client => Statsd.instance)


# Create our Connection object that knows about our Protobuf service
# definition
def connection
  return @connection if @connection

  @connection = Elementary::Connection.new(Echoserv::Simple,
                                             :hosts => hosts)
end
# Create a Protobuf message to send over RPC
msg = Echoserv::String.new(:data => str)


echoed = c.rpc.echo(msg) # => Elementary::Future
reversed = c.rpc.reverse(msg) # => Elementary::Future

sleep 10 # Twiddle our thumbs doing other things

puts {
  :echoed => echoed.value, # resolve the future and get our value out
  :reversed => reversed.value,
}.to_json
```

## Installation

Add this line to your application's Gemfile:

    gem 'elementary-rpc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install elementary-rpc

## Contributing

1. Fork it ( https://github.com/[my-github-username]/elementary-rpc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### Testing

Install ha-proxy for your OS
 For Mac OSX, good reference source is:
 http://nepalonrails.tumblr.com/post/9674428224/setup-haproxy-for-development-environment-on-mac

 Sample ha-proxy config
```ruby
 >cat /etc/haproxy.conf
 global
   maxconn 4096
   pidfile ~/tmp/haproxy-queue.pid
   log /tmp/haproxy/log    local0
   log /tmp/haproxy/log    local1 notice

 defaults
   log global
   mode http
   timeout connect 300000
   timeout client 300000
   timeout server 300000
   maxconn 2000
   option redispatch
   retries 3
   option httpclose
   option httplog
   option forwardfor
   option httpchk HEAD / HTTP/1.0

 frontend http-farm-1
   bind :8080
   default_backend app1latest

 frontend http-farm-2
   bind :8070
   default_backend app2latest

 backend app1latest
   balance roundrobin
   server localhost_8000 localhost:8000

 backend app2latest
   balance roundrobin

 listen haproxyapp_admin:9100 127.0.0.1:9100
   mode http
   stats uri /
```
Start ha-proxy listener

    haproxy -f /etc/haproxy.conf

Start the server hosting the rpc as below:

    bundle exec rpc_server start ./spec/support/simpleservice.rb -p 8000 --http

Run the tests

    bundle exec rspec spec

