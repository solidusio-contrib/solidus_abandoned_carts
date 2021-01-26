# frozen_string_literal: true

namespace :solidus_abandoned_carts do
  task send_notification: :environment do
    Rails.logger.info "Sending abandoned carts notifications..."

    abandoned_cart_count = Spree::Order.abandon_not_notified.count

    Spree::Order.abandon_not_notified.find_each do |order|
      SolidusAbandonedCarts::Config.notifier_class.new(order).call(:deliver_later)
    end

    Rails.logger.info "notifications sent: #{abandoned_cart_count}"
  end
end
