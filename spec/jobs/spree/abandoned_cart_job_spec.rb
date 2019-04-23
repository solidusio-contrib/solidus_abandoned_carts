# frozen_string_literal: true

RSpec.describe Spree::AbandonedCartJob, type: :job do
  let(:email) { 'test@email.com' }

  before do
    allow(Spree::AbandonedCartMailer)
      .to receive(:abandoned_cart_email)
      .and_call_original
  end

  context 'with an email address' do
    it 'sends an email' do
      expect {
        subject.perform
      }.to have_enqueued_job(Spree::AbandonedCartJob)
    end
  end

  context 'with no email address' do
    let(:email) { nil }

    it 'sends an email' do
      subject.perform
      expect(Spree::AbandonedCartMailer)
        .to_not have_received(:abandoned_cart_email)
    end
  end
end
