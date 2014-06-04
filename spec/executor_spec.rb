require 'spec_helper'
require 'elementary/executor'

describe Elementary::Executor do
  let(:executor) { described_class.new(service, transport) }
  let(:service) { nil }
  let(:transport) { nil }

  describe '#middleware' do
    subject(:middleware) { executor.middleware }

    it { should be_instance_of Array }
  end
end
