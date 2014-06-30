require 'spec_helper'
require 'elementary/future'

describe Elementary::Future do
  let(:future) { described_class.new do 1 end }

  describe '#method_missing' do
    context 'methods defined on Concurrent::Future' do
      it 'should invoke the methods directly on the future' do
        expect(future).to receive(:value)
        future.value
      end
    end

    context 'methods not defined on Concurrent::Future' do
      let(:actual) do
        double('Elementary::Future#value mock')
      end

      before :each do
        expect(future).to receive(:value).and_return(actual)
      end

      it 'should invoke the method on the value of the future' do
        value = 1337
        expect(actual).to receive(:number).and_return(value)

        expect(future.number).to eql(value)
      end

      it 'should invoke the method with params on the value of the future' do
        expect(actual).to receive(:add).with(2, 2).and_return(5)

        expect(future.add(2, 2)).to eql(5)
      end
    end
  end

  describe '#execute' do
    subject(:future) do
      described_class.new do
        rval
      end
    end

    context 'when concurrency has been disabled' do
      let(:rval) { 'rspec' }
      before :each do
        expect(Elementary).to receive(:synchronous?).and_return(true).twice
      end

      it 'should invoke the block' do
        r = future.execute
        expect(r).to be_instance_of described_class
        expect(r.value).to eql(rval)
      end
    end
  end
end
