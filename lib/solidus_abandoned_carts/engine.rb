# frozen_string_literal: true

require 'spree/core'

module SolidusAbandonedCarts
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions

    isolate_namespace Spree

    engine_name 'solidus_abandoned_carts'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'solidus_abandoned_carts.environment', before: :load_config_initializers do
      SolidusAbandonedCarts::Config = SolidusAbandonedCarts::Configuration.new
    end
  end
end
