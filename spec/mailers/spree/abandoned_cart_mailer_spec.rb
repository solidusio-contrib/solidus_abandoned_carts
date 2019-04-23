# frozen_string_literal: true

RSpec.describe Spree::AbandonedCartMailer do
  describe '.abandoned_cart_email' do
    subject(:email) { described_class.abandoned_cart_email(order) }

    let(:order) { build_stubbed(:order) }

    it "is sent to the order's email" do
      expect(email.to).to eq([order.email])
    end
  end
end
