# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'midnight/version'

Gem::Specification.new do |spec|
  spec.name          = "midnight"
  spec.version       = Midnight::VERSION
  spec.authors       = ["bluefuton"]
  spec.email         = ["chris@bluefuton.com"]
  spec.summary       = %q{Parse natural language date/time into a cron expression}
  spec.description   = ''
  spec.homepage      = 'https://github.com/bluefuton/midnight'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.0.0"
  spec.add_development_dependency "rake", '~> 0'
  spec.add_development_dependency 'test-unit'
  spec.add_dependency 'chronic', '=0.10.2'
  spec.add_dependency 'numerizer', '~> 0.1.1'
end
