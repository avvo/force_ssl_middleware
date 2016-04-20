# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'force_ssl_middleware/version'

Gem::Specification.new do |spec|
  spec.name          = "force_ssl_middleware"
  spec.version       = ForceSslMiddleware::VERSION
  spec.authors       = ["Donald Plummer"]
  spec.email         = ["dplummer@avvo.com"]

  spec.summary       = %q{Same as ActionDispatch::SSL, add support for excluded_paths}
  spec.homepage      = "https://github.com/avvo/force_ssl_middleware"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
