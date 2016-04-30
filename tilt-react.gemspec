# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tilt/react/version'

Gem::Specification.new do |spec|
  spec.name          = "tilt-react"
  spec.version       = Tilt::React::VERSION
  spec.authors       = ["JP Hastings-Spital"]
  spec.email         = ["jphastings@gmail.com"]

  spec.summary       = %q{Use React.js JSX files as view templates in Sinatra and other Tilt powered frameworks.}
  spec.description   = %q{Render React.js JSX files with the Tilt templating system.}
  spec.homepage      = "https://github.com/jphastings/tilt-react"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'rack-accept', '~> 0.4'
  spec.add_dependency 'therubyracer', '~> 0.12'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'nokogiri', '~> 1.6'
  spec.add_development_dependency 'capybara', '~> 2.6'
  spec.add_development_dependency 'rspec-as_fixture', '~> 0.1'
end
