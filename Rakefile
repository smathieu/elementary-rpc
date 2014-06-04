require "bundler/gem_tasks"
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

task :default => ['protobuf:spec', 'spec', 'build']

namespace :protobuf do
  desc 'Generate rspec protos'
  task :spec do
    sh "protoc --proto_path=./spec/support/proto --ruby_out=./spec/support #{Dir['./spec/support/proto/**/*.proto'].join(' ')}"
  end
end
