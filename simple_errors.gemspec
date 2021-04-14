# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_errors/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_errors"
  spec.version       = SimpleErrors::VERSION
  spec.authors       = ["Ed Jones"]
  spec.email         = ["ed@errorstudio.co.uk"]
  spec.summary       = %q{A simple way to rescue errors in rails apps}
  spec.description   = %q{We're forever writing the same rescue code for our Rails apps. This gem will hopefully stop that :-)}
  spec.homepage      = "https://github.com/errorstudio/simple_errors"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "rails", ">= 4.2", "< 7.0.0"
end
