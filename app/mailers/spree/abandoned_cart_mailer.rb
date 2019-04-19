# frozen_string_literal: true

module Spree
  class AbandonedCartMailer < BaseMailer
    def abandoned_cart_email(order)
      @order = order
      @store = @order.store
      subject = "#{@store.name} - #{Spree.t(:abandoned_cart_subject)}"

      mail(to: order.email, from: from_address(@store), subject: subject) if @order.email.present?
    end
  end
end
