# frozen_string_literal: true

module Spree
  class NotifyAbandonedCartJob < ActiveJob::Base
    queue_as :default

    def perform(order)
      return unless order.last_for_user?

      SolidusAbandonedCarts::Config.notifier_class.new(order).call
    end
  end
end
