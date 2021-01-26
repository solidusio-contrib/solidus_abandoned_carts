# frozen_string_literal: true

RSpec.describe 'solidus_abandoned_carts:send_notification' do
  let(:user) { create :user }

  let!(:order_a) do
    create :order, item_count: 1, user: user, email: user.email,
      abandoned_cart_email_sent_at: nil, updated_at: 50.hours.ago
  end

  let!(:order_b) do
    create :order, item_count: 1, user: user, email: user.email,
      abandoned_cart_email_sent_at: nil, updated_at: 48.hours.ago
  end

  before { clear_enqueued_jobs }

  describe '#perform' do
    include_context(
      'rake',
      task_path: 'lib/tasks/solidus_abandoned_carts/send_notification.rake',
      task_name: 'solidus_abandoned_carts:send_notification',
    )

    it 'will send abandoned cart emails' do
      task.invoke

      expect(ActionMailer::Base.deliveries.size).to be 0
      expect(enqueued_jobs.size).to be 1

      expect(order_a.reload.abandoned_cart_email_sent_at).to be_nil
      expect(order_b.reload.abandoned_cart_email_sent_at).not_to be_nil
    end
  end
end
