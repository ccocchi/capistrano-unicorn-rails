# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-unicorn-rails'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-unicorn-rails"
  spec.version       = CapistranoUnicornRails::VERSION
  spec.authors       = ["ccocchi"]
  spec.email         = ["cocchi.c@gmail.com"]
  spec.description   = "Simple Unicorn! integration with Capistrano3 for Rails projects"
  spec.summary       = "Basic tasks for starting and stoping Unicorn! servers via capistrano tasks"
  spec.homepage      = "https://github.com/ccocchi/capistrano-unicorn-rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'rake'

  spec.add_runtime_dependency 'capistrano', '>= 3.0.1'
end
