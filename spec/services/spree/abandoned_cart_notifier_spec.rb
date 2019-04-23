# frozen_string_literal: true

RSpec.describe Spree::AbandonedCartNotifier do
  subject(:notifier) { described_class.new(order) }

  let(:order) do
    instance_spy('Spree::Order', abandoned_cart_email_sent_at: abandoned_cart_email_sent_at)
  end

  let(:email) { instance_spy('ActionMailer::Delivery') }

  before do
    allow(Spree::AbandonedCartMailer).to receive(:abandoned_cart_email)
      .with(order)
      .and_return(email)
  end

  context 'when the order has not been notified yet' do
    let(:abandoned_cart_email_sent_at) { nil }

    it 'sends send the abandoned cart email' do
      notifier.call

      expect(email).to have_received(:deliver_now)
    end

    it 'touches abandoned_cart_email_sent_at' do
      notifier.call

      expect(order).to have_received(:touch).with(:abandoned_cart_email_sent_at)
    end
  end

  context 'when the order has already been notified' do
    let(:abandoned_cart_email_sent_at) { Time.zone.now }

    it 'does not send the abandoned cart email' do
      notifier.call

      expect(email).not_to have_received(:deliver_now)
    end
  end
end
