# frozen_string_literal: true

module Spree
  class ScheduleAbandonedCartsJob < ActiveJob::Base
    queue_as :default

    def perform
      Spree::Order.abandon_not_notified.find_each do |order|
        next unless order.last_for_user?

        Spree::NotifyAbandonedCartJob.perform_later(order)
      end
    end
  end
end
