# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zstats/version'

Gem::Specification.new do |spec|
  spec.name          = "zstats"
  spec.version       = ZStats::VERSION
  spec.authors       = ["zvkemp"]
  spec.email         = ["zvkemp@gmail.com"]
  spec.description   = %q{Simple statistics}
  spec.summary       = %q{Simple statistics}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
