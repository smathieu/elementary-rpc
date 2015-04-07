require "bundler/gem_tasks"
require 'rspec/core/rake_task'

task :default => [:spec, :build]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = '--tag ~type:integration'
end

namespace :spec do
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.rspec_opts = '--tag type:integration'
  end
end


namespace :protobuf do
  desc 'Generate rspec protos'
  task :spec do
    sh "protoc --proto_path=./spec/support/proto --ruby_out=./spec/support #{Dir['./spec/support/proto/**/*.proto'].join(' ')}"
  end
end
