class AbandonedCartWorker
  include Sidekiq::Worker if defined?(Sidekiq)

  def perform
    Spree::Order.abandon_not_notified.each do |order|
      next unless order.last_for_user?
      order.abandoned_cart_actions
    end

    if self.class.respond_to?(:perform_in)
      next_run = SpreeAbandonedCarts::Config.worker_frequency_minutes
      self.class.perform_in(next_run.minutes) if next_run > 0
    end
  end
end
