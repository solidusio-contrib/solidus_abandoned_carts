module SpreeAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
    preference :abandoned_states, :array, default: [:cart, :address, :delivery, :payment, :confirm]
    preference :abandoned_after_minutes, :integer, default: 1440
    preference :worker_frequency_minutes, :integer, default: 30
  end
end
