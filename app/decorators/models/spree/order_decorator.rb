# frozen_string_literal: true

module SolidusAbandonedCarts
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.scope :abandoned, ->(time = Time.current - SolidusAbandonedCarts::Config.abandoned_after_minutes.minutes) do
          incomplete.
            where('email IS NOT NULL').
            where('item_count > 0').
            where('updated_at < ?', time)
        end

        base.scope :abandon_not_notified, -> { abandoned.where(abandoned_cart_email_sent_at: nil) }
      end

      def abandoned_cart_actions
        abandoned_cart_class.abandoned_cart_email(self).deliver_now
        touch(:abandoned_cart_email_sent_at)
      end

      def last_for_user?
        ::Spree::Order.where(email: email).where('id > ?', id).none?
      end

      private

      def abandoned_cart_class
        ::Spree::Config.abandoned_cart_mailer_class
      end

      ::Spree::Order.prepend self
    end
  end
end
