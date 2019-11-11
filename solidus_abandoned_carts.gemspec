# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
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
  s.homepage  = 'http://github.com/jtapia/solidus_abandoned_carts'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'deface', '~> 1.0'
  s.add_dependency 'solidus', ['>= 2.0', '< 3']
  s.add_dependency 'solidus_support', '~> 0.3.3'

  s.add_development_dependency 'solidus_extension_dev_tools'
end
