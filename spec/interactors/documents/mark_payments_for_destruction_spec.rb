require 'rails_helper'

RSpec.describe Documents::MarkPaymentsForDestruction, type: :interactor do
  describe '.call' do
    subject { described_class.call(document: document) }

    let(:document) { instance_double(BookingInvoice, payments: payments) }
    let(:payment1) { double(:payment1, price_cents: price) }
    let(:payment2) { double(:payment2, price_cents: price) }
    let(:payments) { [payment1, payment2] }

    before do
      allow(payment1).to receive(:mark_for_destruction) { true }
      allow(payment2).to receive(:mark_for_destruction) { true }
    end

    describe "mark payments for destruction if zero" do
      let(:price) { 0 }

      it { is_expected.to be_success }

      it do
        expect(payment1).to receive(:mark_for_destruction)
        expect(payment2).to receive(:mark_for_destruction)

        subject
      end
    end

    describe "don't mark if price is not zero" do
      let(:price) { 10 }

      it { is_expected.to be_success }

      it do
        expect(payment1).not_to receive(:mark_for_destruction)
        expect(payment2).not_to receive(:mark_for_destruction)

        subject
      end
    end
  end
end
