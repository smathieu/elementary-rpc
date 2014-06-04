require 'spec_helper'
require 'elementary/connection'

describe Elementary::Connection do
  describe '#initialize' do
    subject(:connection) { described_class.new(service, opts) }
    let(:opts) { {} }

    context 'without a Protobuf::Rpc::Service' do
      let(:service) { nil }

      it 'should raise ArgumentError' do
        expect { connection }.to raise_error(ArgumentError)
      end
    end

    context 'with a Protobuf::Rpc::Service' do
      let(:service) { Elementary::Rspec::Simple }

      it { should be_instance_of described_class }
    end
  end
end
