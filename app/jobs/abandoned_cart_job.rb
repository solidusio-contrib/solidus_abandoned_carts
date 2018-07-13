# frozen_string_literal: true

module Spree
  class AbandonedCartJob < ActiveJob::Base
    queue_as :default

    def perform
      next_run = SolidusAbandonedCarts::Config.worker_frequency_minutes

      Spree::Order.abandon_not_notified.each do |order|
        next unless order.last_for_user?

        order.abandoned_cart_actions
      end

      if self.class.respond_to?(:perform_in)
        self.class.new.perform_in(next_run.minutes) if next_run > 0
      end

      if self.class.respond_to?(:perform_later)
        self.class.set(wait: next_run.minutes).perform_later
      end
    end
  end
end
