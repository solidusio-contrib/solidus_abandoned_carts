# frozen_string_literal: true

SolidusAbandonedCarts::Config.tap do |config|
  # Override timeout which make an order abandoned
  # config.abandoned_timeout = 24.hours

  # Override the abandoned states
  # config.abandoned_states = %i[cart address delivery payment confirm]

  # Override the time which restricts the abandoned orders
  # avoiding that the older ones aren't considered abandoned.
  # Can be set to nil to remove this restriction
  config.abandoned_max_timeout = 1.month

  # Override mailer classes
  # config.mailer_class = 'Spree::AbandonedCartMailer'
  # config.notifier_class = 'Spree::AbandonedCartNotifier'

  # Override job classes
  # config.notifier_job_class = 'Spree::NotifyAbandonedCartJob'
  # config.schedule_job_class = 'Spree::ScheduleAbandonedCartsJob'
end
