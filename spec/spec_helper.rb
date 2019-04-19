# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

begin
  require File.expand_path('dummy/config/environment', __dir__)
rescue LoadError
  puts 'Could not load dummy application. Please ensure you have run `bundle exec rake test_app`'
  exit
end

Dir[File.join(File.dirname(__FILE__), '/support/**/*.rb')].each { |file| require file }

require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
