# frozen_string_literal: true

RSpec.describe Spree::NotifyAbandonedCartJob, type: :job do
  subject { -> { described_class.perform_now(order) } }

  let(:order) { instance_spy('Spree::Order', last_for_user?: last_for_user) }

  let(:notifier) { instance_spy('Spree::AbandonedCartNotifier') }

  before do
    allow(Spree::AbandonedCartNotifier).to receive(:new)
      .with(order)
      .and_return(notifier)
  end

  context "when the order is the user's last" do
    let(:last_for_user) { true }

    it 'runs the notifier class' do
      subject.call

      expect(notifier).to have_received(:call)
    end
  end

  context "when the order is not the user's last anymore" do
    let(:last_for_user) { false }

    it 'does not run the notifier class' do
      subject.call

      expect(notifier).not_to have_received(:call)
    end
  end
end
