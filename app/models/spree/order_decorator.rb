module OrderDecorator
  def self.included(base)
    base.scope :abandoned, ->(time = Time.current - SolidusAbandonedCarts::Config
      .abandoned_after_minutes.minutes) do
      incomplete.
      where('email IS NOT NULL').
      where('item_count > 0').
      where('updated_at < ?', time)
    end

    base.scope :abandon_not_notified, -> do
      abandoned.where(abandoned_cart_email_sent_at: nil)
    end

    def abandoned_cart_actions
      abandoned_cart_class.abandoned_cart_email(self).deliver_now
      touch(:abandoned_cart_email_sent_at)
    end

    def last_for_user?
      Spree::Order.where(email: email).where('id > ?', id).none?
    end

    protected

    def abandoned_cart_class
      if Spree.respond_to?(:solidus_version) && Spree.solidus_version > '2.4'
        Spree::Config.abandoned_cart_mailer_class
      else
        Spree::AbandonedCartMailer
      end
    end
  end
end

Spree::Order.include(OrderDecorator)
