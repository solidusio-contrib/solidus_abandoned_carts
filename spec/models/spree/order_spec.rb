# frozen_string_literal: true

RSpec.describe Spree::Order do
  let(:abandoned_date) do
   DateTime.now - SolidusAbandonedCarts::Config.abandoned_date.to_i.days
  end
  let(:abandoned_timeout) do
    SolidusAbandonedCarts::Config.abandoned_timeout
  end

  subject(:order) { create(:order) }

  describe '.abandoned' do
    let!(:abandoned_order) do
      create(:order,
        updated_at: abandoned_date - abandoned_timeout,
        item_count: 100,
      )
    end

    before do
      # Not abandoned, with email, with items
      create(:order, item_count: 100)

      # Abandoned, with email, no items
      create(:order,
        updated_at: abandoned_date - abandoned_timeout,
        item_count: 0,
      )

      # Abandoned, no email, with items
      create(:order,
        updated_at: abandoned_date - abandoned_timeout,
        item_count: 100,
      ).update!(email: nil)
    end

    it 'returns orders that are abandoned, have an email and have items' do
      expect(described_class.abandoned).to match_array([abandoned_order])
    end
  end

  describe '.abandon_not_notified' do
    let!(:abandoned_order) do
      create(:order,
        updated_at: abandoned_date - abandoned_timeout,
        item_count: 100,
      )
    end

    before do
      # Abandoned but notified
      create(:order,
        updated_at: abandoned_date - abandoned_timeout,
        item_count: 100,
        abandoned_cart_email_sent_at: abandoned_date,
      )
    end

    it 'returns orders that are abandoned and not notified' do
      expect(described_class.abandon_not_notified).to match_array([abandoned_order])
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
        create(:order).update_columns(
          email: order.email,
          created_at: order.created_at + 1.minute
        )
      end

      it 'returns false' do
        expect(order).not_to be_last_for_user
      end
    end
  end
end
