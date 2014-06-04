# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elementary/version'

Gem::Specification.new do |spec|
  spec.name          = "elementary-rpc"
  spec.version       = Elementary::VERSION
  spec.authors       = ["R. Tyler Croy"]
  spec.email         = ["tyler@monkeypox.org"]
  spec.summary       = "Gem supporting Protobuf RPC in a simple way"
  spec.description   = "BLANK"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency 'concurrent-ruby', '~> 0.6.0'
  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'lookout-statsd', '~> 0.9.0'
end
