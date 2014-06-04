require 'spec_helper'
require 'elementary/middleware/statsd'

describe Elementary::Middleware::Statsd do
  let(:statsd) { described_class.new(nil) }

  describe '#metric_name' do
    subject(:metric) { statsd.metric_name(service_name, method_name) }

    let(:service_name) { 'My::Rpc::Service' }
    let(:method_name) { 'echo' }

    it { should eql 'elementary.my.rpc.service.echo' }
  end
end
