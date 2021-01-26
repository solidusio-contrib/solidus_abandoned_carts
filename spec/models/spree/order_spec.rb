# frozen_string_literal: true

RSpec.describe Spree::Order do
  subject(:order) { create(:order) }

  before do
    stub_spree_preferences(SolidusAbandonedCarts::Config, abandoned_timeout: 24.hours)
  end

  describe '.abandoned' do
    let!(:abandoned_order) do
      create(
        :order,
        updated_at: Time.zone.now - SolidusAbandonedCarts::Config.abandoned_timeout - 1.second,
        item_count: 100,
      )
    end

    before do
      # Not abandoned, with email, with items
      create(:order, item_count: 100)

      # Abandoned, with email, no items
      create(
        :order,
        updated_at: Time.zone.now - SolidusAbandonedCarts::Config.abandoned_timeout - 1.second,
        item_count: 0,
      )

      # Abandoned, no email, with items
      create(
        :order,
        updated_at: Time.zone.now - SolidusAbandonedCarts::Config.abandoned_timeout - 1.second,
        item_count: 100,
      ).update!(email: nil)
    end

    it 'returns orders that are abandoned, have an email and have items' do
      expect(described_class.abandoned).to match_array([abandoned_order])
    end
  end

  describe '.abandon_not_notified' do
    let!(:first_abandoned_order) do
      create(
        :order,
        updated_at: abandoned_timeout,
        item_count: 100,
      )
    end

    let!(:second_abandoned_order) do
      # Abandoned but too old with max_timeout set
      create(
        :order,
        updated_at: abandoned_timeout - 1.month,
        item_count: 100
      )
    end

    let(:abandoned_timeout) { Time.current - SolidusAbandonedCarts::Config.abandoned_timeout - 1.second }

    before do
      stub_spree_preferences(SolidusAbandonedCarts::Config, abandoned_max_timeout: abandoned_max_timeout)

      # Abandoned but notified
      create(
        :order,
        updated_at: abandoned_timeout,
        item_count: 100,
        abandoned_cart_email_sent_at: Time.zone.now,
      )
    end

    context 'when the max_timeout configuration is set' do
      let(:abandoned_max_timeout) { 1.month }

      it 'returns orders that are abandoned and not notified' do
        expect(described_class.abandon_not_notified).to match_array([first_abandoned_order])
      end
    end

    context 'when the max_timeout configuration is not set' do
      let(:abandoned_max_timeout) { nil }

      it 'returns orders that are abandoned and not notified' do
        expect(described_class.abandon_not_notified).to match_array([first_abandoned_order, second_abandoned_order])
      end
    end
  end

  describe '#last_for_user?' do
    context 'when user does not have other orders' do
      it 'returns true' do
        expect(order).to be_last_for_user
      end
    end

    context 'when user has newer orders' do
      before do
        create(:order).update!(email: order.email, created_at: order.created_at + 1.minute)
      end

      it 'returns false' do
        expect(order).not_to be_last_for_user
      end
    end
  end
end
