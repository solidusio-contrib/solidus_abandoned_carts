# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_abandoned_carts/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_abandoned_carts'
  s.version     = SolidusAbandonedCarts::VERSION
  s.summary     = 'Take some action for abandoned carts'
  s.description = s.summary
  s.license     = 'BSD-3-Clause'
  s.author    = 'Jonathan Tapia'
  s.email     = 'jonathan.tapia@magmalabs.io'
  s.homepage  = 'https://github.com/solidusio-contrib/solidus_abandoned_carts'

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.required_ruby_version = '~> 2.4'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'deface', '~> 1.0'
  s.add_dependency 'solidus', ['>= 2.0.0', '< 4']
  s.add_dependency 'solidus_support', '~> 0.5'

  s.add_development_dependency 'solidus_dev_support'
end
