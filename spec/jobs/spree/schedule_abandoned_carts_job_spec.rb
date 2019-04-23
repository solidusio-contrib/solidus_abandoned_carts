# frozen_string_literal: true

RSpec.describe Spree::ScheduleAbandonedCartsJob, type: :job do
  subject { -> { described_class.perform_now } }

  let(:order) { instance_double('Spree::Order', last_for_user?: last_for_user) }

  before do
    relation = instance_double('Spree::Order::ActiveRecord_Relation')
    allow(Spree::Order).to receive(:abandon_not_notified).and_return(relation)
    allow(relation).to receive(:find_each).and_yield(order)
    stub_const('Spree::NotifyAbandonedCartJob', class_spy('Spree::NotifyAbandonedCartJob'))
  end

  context "when an order is the user's last" do
    let(:last_for_user) { true }

    it 'gets scheduled for notification' do
      subject.call

      expect(Spree::NotifyAbandonedCartJob).to have_received(:perform_later).with(order)
    end
  end

  context "when an order is not the user's last" do
    let(:last_for_user) { false }

    it 'gets scheduled for notification' do
      subject.call

      expect(Spree::NotifyAbandonedCartJob).not_to have_received(:perform_later)
    end
  end
end
