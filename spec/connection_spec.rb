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

  context 'with an opts hash' do
    subject(:connection) { described_class.new(Elementary::Rspec::Simple, opts) }

    context 'with symbolic keys' do
      let(:opts) { { :hosts => [{:host => 'foo', :prefix => '/bar'}] } }

      it { should be_instance_of described_class }

      it 'should have one host, with a host key and a prefix key' do
        hosts = connection.instance_variable_get(:@hosts)

        expect(hosts.size).to be 1
        expect(hosts.first[:host]).to eql opts[:hosts].first[:host]
        expect(hosts.first[:prefix]).to eql opts[:hosts].first[:prefix]
      end
    end

    context 'with string keys' do
      let(:opts) { { 'hosts' => [{'host' => 'foo', 'prefix' => '/bar'}] } }

      it { should be_instance_of described_class }

      it 'should have one host, with a host key and a prefix key' do
        hosts = connection.instance_variable_get(:@hosts)

        expect(hosts.size).to be 1
        expect(hosts.first[:host]).to eql opts['hosts'].first['host']
        expect(hosts.first[:prefix]).to eql opts['hosts'].first['prefix']
      end
    end
  end

  context 'with a simple RPC service' do
    let(:opts) { {} }
    let(:connection) do
      described_class.new(Elementary::Rspec::Simple, opts)
    end
    describe '#select_transport' do
      subject(:transport) { connection.select_transport }

      context 'by default' do
        it { should be_instance_of Elementary::Transport::HTTP }
      end

      context 'with transport_options' do
        let(:opts) { {:transport_options => transport_opts} }
        let(:transport_opts) do
          Hashie::Mash.new({
            :timeout => 3,
            :open_timeout => 1,
          })
        end

        it 'should pass request_options to the transport' do
          expect(Elementary::Transport::HTTP).to receive(:new).with(anything, transport_opts).and_call_original
          expect(transport).to be_instance_of Elementary::Transport::HTTP
        end
      end
    end

    describe 'an error request', :type => :integration do
      describe 'rpc' do
        describe '#error' do
          subject(:response) { connection.rpc.error(request) }
          let(:request) { Elementary::Rspec::String.new(:data => 'rspec') }

          before :each do
            response.value
          end

          it { should be_rejected }
        end
      end
    end

    describe 'an echo request', :type => :integration do
      after :each do
        Elementary.flush_middleware
      end

      describe 'rpc' do
        describe '#echo' do
          let(:request) { Elementary::Rspec::String.new(:data => 'rspec') }
          context 'with http connection failure due to haproxy resolving service to wrong host or port' do
            let(:opts) { { 'hosts' => [{'host' => 'localhost', 'port' => '8090'}] } }
            subject(:response) { connection.rpc.echo(request) }

            before :each do
              response.value
            end

            it { should be_rejected }
            it { should be_instance_of Elementary::Future }
            it 'should have a connection refused reason' do
              expect(response.reason).not_to be_nil
              expect(response.reason.to_s).to eq("connection refused: localhost:8090")
            end
          end
          context 'with http connection success' do
            let(:opts) { { 'hosts' => [{'host' => 'localhost', 'port' => '8000'}] } }
            subject(:response) { connection.rpc.echo(request) }

            before :each do
              Elementary.use Elementary::Middleware::Dummy, :rspec => true
              expect_any_instance_of(Elementary::Middleware::Dummy).to \
                      receive(:call).and_call_original
            end

            it 'should have a value containing the echoed string' do
              expect(response).to be_instance_of Elementary::Future
              value = response.value # Wait on the future
              expect(response).not_to be_rejected
              expect(value.data).to eql('rspec')
            end
          end

          context 'with :future_options specifying a Concurrent::Executor' do
            class MyExecutor < Concurrent::ImmediateExecutor
              attr_reader :post_count
              def initialize
                super
                @post_count = 0
              end
              def post(*args, &task)
                @post_count = @post_count + 1
                super
              end
            end
            let(:my_executor) { MyExecutor.new }
            let(:opts) { { 'hosts' => [{'host' => 'localhost', 'port' => '8000'}],
                           :future_options => { :executor => my_executor } } }
            subject(:response) { connection.rpc.echo(request) }

            it 'should run on the specified executor' do
              expect(response).to be_instance_of Elementary::Future
              response.value # Wait on the future
              expect(my_executor.post_count).to be 1
            end
          end
         end
      end
    end
  end
end
