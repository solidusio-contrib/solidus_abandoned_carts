module Spree
  class AbandonedCartMailer < BaseMailer
    def abandoned_cart_email(order)
      @order = order
      mail(to: order.email, from: from_address, subject: Spree.t(:abandoned_cart_subject))
    end
  end
end
