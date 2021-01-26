# frozen_string_literal: true

module SolidusAbandonedCarts
  class Configuration < Spree::Preferences::Configuration
    preference :abandoned_states, :array, default: %i[cart address delivery payment confirm]
    preference :abandoned_timeout, :time, default: 24.hours
    preference :abandoned_max_timeout, :time, default: 1.week

    alias abandoned_retroactivity abandoned_max_timeout

    class_name_attribute :mailer_class, default: 'Spree::AbandonedCartMailer'
    class_name_attribute :notifier_class, default: 'Spree::AbandonedCartNotifier'
    class_name_attribute :notifier_job_class, default: 'Spree::NotifyAbandonedCartJob'
    class_name_attribute :schedule_job_class, default: 'Spree::ScheduleAbandonedCartsJob'
  end
end
