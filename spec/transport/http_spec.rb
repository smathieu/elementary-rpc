require 'spec_helper'
require 'elementary/transport/http'

describe Elementary::Transport::HTTP do
  let(:hosts) { [] }
  let(:http) { described_class.new(hosts) }

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
