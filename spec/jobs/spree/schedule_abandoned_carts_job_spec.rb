# frozen_string_literal: true

RSpec.describe Spree::ScheduleAbandonedCartsJob, type: :job do
  let(:user) { create :user }
  let!(:order) do
    create :order, item_count: 1, completed_at: nil, email: user.email,
      user: user, abandoned_cart_email_sent_at: nil, updated_at: 26.hours.ago
  end

  before { clear_enqueued_jobs }

  context "when an order is the user's last" do
    it 'gets scheduled for notification' do
      described_class.perform_now

      order.reload
      expect(ActionMailer::Base.deliveries.size).to be 0
      expect(enqueued_jobs.size).to be 1

      expect(order.abandoned_cart_email_sent_at).not_to be_nil
    end
  end

  context 'when an order is not the user\'s last' do
    let!(:new_order) do
      create :order, item_count: 1, completed_at: nil, email: order.email,
        user: user, abandoned_cart_email_sent_at: nil, updated_at: 25.hours.ago
    end

    it 'will not send a notification out' do
      described_class.perform_now

      order.reload
      new_order.reload

      expect(ActionMailer::Base.deliveries.size).to be 0
      expect(enqueued_jobs.size).to be 1

      expect(order.abandoned_cart_email_sent_at).to be_nil
      expect(new_order.abandoned_cart_email_sent_at).not_to be_nil
    end
  end
end
