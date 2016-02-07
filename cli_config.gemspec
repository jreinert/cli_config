# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cli_config/version'

Gem::Specification.new do |spec|
  spec.name          = 'cli_config'
  spec.version       = CLIConfig::VERSION
  spec.authors       = ['Joakim Reinert']
  spec.email         = ['mail+gems@jreinert.com']

  spec.summary       = 'A tiny gem for handling configs for command line apps'
  spec.description   = 'Provides dsl heavily based on solnic/virtus for' \
                       'specifying options that will be filled from yaml' \
                       'or command line options via OptionParser'
  spec.homepage      = 'https://github.com/jreinert/cli_config'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_runtime_dependency 'virtus', '~> 1.0'
  spec.add_runtime_dependency 'activesupport', '~> 4.2'
end
