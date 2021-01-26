# frozen_string_literal: true

module Spree
  class ScheduleAbandonedCartsJob < ActiveJob::Base
    queue_as :default

    def perform
      Spree::Order.abandon_not_notified.find_each do |order|
        SolidusAbandonedCarts::Config.notifier_class.new(order).call(:deliver_later)
      end
    end
  end
end
