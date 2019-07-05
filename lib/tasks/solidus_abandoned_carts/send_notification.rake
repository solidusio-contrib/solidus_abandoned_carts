# frozen_string_literal: true

namespace :solidus_abandoned_carts do
  task send_notification: :environment do
    puts "Sending abandoned carts notifications..."

    abandonded_carts = Spree::Order.abandon_not_notified
    if abandonded_carts
      abandonded_carts.find_each do |order|
        next unless order.last_for_user?

        Spree::NotifyAbandonedCartJob.perform_now(order)
      end if abandonded_carts

      puts "notifications sent: #{abandonded_carts.count}"
    end

    puts "Done!"
  end
end
