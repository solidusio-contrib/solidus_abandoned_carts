# frozen_string_literal: true

module Spree
  class ScheduleAbandonedCartsJob < ActiveJob::Base
    queue_as :default

    def perform
      Spree::Order.abandon_not_notified.find_each do |order|
        next unless order.last_for_user?

        SolidusAbandonedCarts::Config.notifier_job_class.perform_later(order)
      end
    end
  end
end
