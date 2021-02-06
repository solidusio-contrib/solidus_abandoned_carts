# frozen_string_literal: true

RSpec.describe 'solidus_abandoned_carts:send_notification' do
  let(:user) { create(:user) }
  let!(:order1) do
    order = create(:order_with_line_items, user: user)
    order.update(updated_at: (Time.current - 48.hours),
                            abandoned_cart_email_sent_at: nil)
    order
  end
  let!(:order2) do
    order = create(:order_with_line_items, user: user)
    order.update(updated_at: (Time.current - 48.hours),
                            abandoned_cart_email_sent_at: nil)
    order
  end

  context 'perform' do
    include_context(
      'rake',
      task_path: 'lib/tasks/solidus_abandoned_carts/send_notification.rake',
      task_name: 'solidus_abandoned_carts:send_notification',
    )

    it 'runs' do
      expect { task.invoke }.to output(
        "Sending abandoned carts notifications...\nnotifications sent: 1\nDone!\n"
      ).to_stdout
    end
  end
end
