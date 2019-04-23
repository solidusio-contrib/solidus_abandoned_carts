# frozen_string_literal: true

module SolidusAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
    preference :abandoned_states, :array, default: %i[cart address delivery payment confirm]
    preference :abandoned_timeout, :time, default: 24.hours
    preference :notifier_class, :string, default: 'Spree::AbandonedCartNotifier'
  end
end
