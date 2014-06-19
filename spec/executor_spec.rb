require 'spec_helper'
require 'elementary/executor'

describe Elementary::Executor do
  let(:executor) { described_class.new(service, transport) }
  let(:service) { nil }
  let(:transport) { nil }
end
