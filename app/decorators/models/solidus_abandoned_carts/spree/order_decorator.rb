# frozen_string_literal: true

module SolidusAbandonedCarts
  module Spree
    module OrderDecorator
      def self.prepended(base)
        base.scope :abandoned, -> (time = Time.current - SolidusAbandonedCarts::Config.abandoned_timeout) do
          selected_orders =
            incomplete
            .where('item_count > 0')
            .where('updated_at < ?', time)
            .where.not(email: nil)
            .group(:email)
            .select(:email, 'MAX(updated_at) AS updated_at')

          joins(<<~SQL.squish)
            INNER JOIN (#{selected_orders.to_sql}) AS so
              ON spree_orders.email = so.email
              AND spree_orders.updated_at = so.updated_at
          SQL
        end

        base.scope :abandon_not_notified, -> do
          relation = abandoned.where(abandoned_cart_email_sent_at: nil)

          if SolidusAbandonedCarts::Config.abandoned_max_timeout
            retroactivity = Time.current - SolidusAbandonedCarts::Config.abandoned_max_timeout
            relation = relation.where('spree_orders.updated_at > ?', retroactivity)
          end

          relation
        end
      end

      def last_for_user?
        ::Spree::Order.where(email: email).where('created_at > ?', created_at).none?
      end

      ::Spree::Order.prepend self
    end
  end
end
