# frozen_string_literal: true

RSpec.describe Spree::Order do
  let(:abandoned_time) { Time.current - SolidusAbandonedCarts::Config.abandoned_after_minutes.minutes - 1.second }
  let!(:abandoned_order) { create(:order, updated_at: abandoned_time, item_count: 100) }

  describe '.abandoned' do
    let!(:fresh_order) { create(:order, item_count: 100) }
    let!(:empty_order) { create(:order, updated_at: abandoned_time, item_count: 0) }
    let!(:order_without_email) do
      create(:order, updated_at: abandoned_time, item_count: 100).update_attributes(email: nil)
    end

    subject { described_class.abandoned }

    it { is_expected.to match_array([abandoned_order]) }
  end

  describe '.abandon_not_notified' do
    let!(:notified_abandoned_order) do
      create(:order, updated_at: abandoned_time, item_count: 100, abandoned_cart_email_sent_at: Time.now)
    end

    subject { described_class.abandon_not_notified }

    it { is_expected.to match_array([abandoned_order]) }
  end

  describe '#abandoned_cart_actions' do
    subject { abandoned_order.abandoned_cart_actions }

    it 'should receive abandoned_cart_email' do
      expect(Spree::AbandonedCartMailer).to receive(:abandoned_cart_email).with(abandoned_order).and_call_original

      subject
    end

    it 'should set #abandoned_cart_email_sent_at' do
      expect { subject }.to change { abandoned_order.abandoned_cart_email_sent_at }
    end
  end

  describe '#last_for_user?' do
    subject { abandoned_order.last_for_user? }

    context 'when user has not another orders' do
      it { is_expected.to be_truthy }
    end

    context 'when user has a new order' do
      before { create(:order).update_attributes(email: abandoned_order.email) }

      it { is_expected.to be_falsey }
    end
  end
end
