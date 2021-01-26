# frozen_string_literal: true

module Spree
  class AbandonedCartNotifier
    def initialize(order)
      @order = order
    end

    def call(delivery = :deliver_now)
      return if order.abandoned_cart_email_sent_at

      SolidusAbandonedCarts::Config.mailer_class.abandoned_cart_email(order).send(delivery)

      order.touch(:abandoned_cart_email_sent_at)
    end

    private

    attr_reader :order
  end
end
