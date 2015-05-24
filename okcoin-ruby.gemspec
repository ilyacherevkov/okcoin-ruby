# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'okcoin/version'

Gem::Specification.new do |spec|
  spec.name          = "okcoin-ruby"
  spec.version       = Okcoin::VERSION
  spec.authors       = ["Ilya Cherevkov"]
  spec.email         = ["icherevkov@gmail.com"]
  spec.summary       = %q{A ruby library for okcoin.com}
  spec.description   = %q{A ruby library for okcoin.com}
  spec.homepage      = "https://github.com/ilyacherevkov/okcoin-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency "curb", "0.8.7"
  spec.add_dependency "celluloid-websocket-client"
end
