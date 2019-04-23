# frozen_string_literal: true

module SolidusAbandonedCarts
  module Spree
    module AppConfigurationDecorator
      def self.prepended(base)
        # Allows providing your own Mailer for abandoned cart mailer.
        #
        # @!attribute [rw] abandoned_cart_mailer_class
        # @return [ActionMailer::Base] an object that responds to "abandoned_cart_email"
        #   (e.g. an ActionMailer with a "abandoned_cart_email" method) with the same
        #   signature as Spree::AbandonedCartMailer.abandoned_cart_email.
        base.class_name_attribute :abandoned_cart_mailer_class, default: 'Spree::AbandonedCartMailer'
      end

      if ::Spree.respond_to?(:solidus_version) && ::Spree.solidus_version > '2.4'
        ::Spree::AppConfiguration.prepend self
      end
    end
  end
end
