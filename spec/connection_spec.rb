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

  let(:connection) do
    described_class.new(Elementary::Rspec::Simple)
  end

  describe '#select_transport' do
    subject(:transport) { connection.select_transport }

    context 'by default' do
      it { should be_instance_of Elementary::Transport::HTTP }
    end
  end

  describe 'an echo request', :type => :integration do
    describe 'rpc' do
      describe '#echo' do
        let(:request) { Elementary::Rspec::String.new(:data => 'rspec') }

        subject(:response) { connection.rpc.echo(request) }

        it 'should have a value containing the echoed string' do
          puts "Sending req #{Time.now.to_f}"
          expect(response).to be_instance_of Elementary::Future

          puts "Waiting for future #{Time.now.to_f}"
          value = response.value # Wait on the future
          puts "Future responded: #{Time.now.to_f}"

          expect(value).to be_instance_of Elementary::Rspec::String
          expect(value.data).to eql('rspec')
        end
      end
    end
  end
end
