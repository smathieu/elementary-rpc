require 'spec_helper'
require 'elementary'

describe Elementary do
  after :each do
    described_class.flush_middleware
  end

  describe '.middleware' do
    subject { described_class.middleware }

    it { should be_instance_of Array }
  end

  describe '.use' do
    let(:mw) { nil }
    subject { described_class.use(mw) }

    context 'with nil' do
      it 'should raise' do
        expect { subject }.to raise_error ArgumentError
      end
    end

    context 'with a class' do
      let(:mw) { Elementary::Middleware::Statsd }

      it { should be true }
    end
  end
end
