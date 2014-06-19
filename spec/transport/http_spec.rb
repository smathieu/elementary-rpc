require 'spec_helper'
require 'elementary/transport/http'

describe Elementary::Transport::HTTP do
  let(:hosts) { [] }
  let(:http) { described_class.new(hosts) }

  describe '#host_url' do
    subject(:host_url) { http.send(:host_url) }

    context 'without a prefix' do
      let(:hosts) do
        [
          {
            :host => 'localhost',
            :port => 8080,
          }
        ]
      end

      it { should eql 'http://localhost:8080/' }
    end

    context 'with a prefix' do
      let(:hosts) do
        [
          {
            :host => 'localhost',
            :port => 8080,
            :prefix => 'rspec'
          }
        ]
      end

      it { should eql 'http://localhost:8080/rspec' }
    end
  end

  describe '#client' do
    let(:hosts) do
      [
        {
          :host => 'localhost',
          :port => 8080,
        }
      ]
    end
    subject(:client) { http.send(:client) }

    it { should be_instance_of Faraday::Connection }

    it 'should cache connections' do
      first = http.send(:client)
      second = http.send(:client)

      # Object identity!
      expect(first).to be second
    end
  end
end
