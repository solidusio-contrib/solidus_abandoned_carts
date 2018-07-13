require 'spree/preferences/configuration'

module Spree
  module AppConfigurationDecorator
    def self.included(base)
      # Allows providing your own Mailer for abandoned cart mailer.
      #
      # @!attribute [rw] abandoned_cart_mailer_class
      # @return [ActionMailer::Base] an object that responds to "abandoned_cart_email"
      #   (e.g. an ActionMailer with a "abandoned_cart_email" method) with the same
      #   signature as Spree::AbandonedCartMailer.abandoned_cart_email.
      base.class_name_attribute :abandoned_cart_mailer_class, default: 'Spree::AbandonedCartMailer'
    end
  end
end

if Spree.respond_to?(:solidus_version) && Spree.solidus_version > '2.4'
  Spree::AppConfiguration.include Spree::AppConfigurationDecorator
end
