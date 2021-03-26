# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingCredits::UpdateBookingCredit, type: :interactor do
  let(:booking_credit) { instance_double(BookingCredit, id: 1, price_cents: 1000, financial_account_id: 1, cost_center_id: 1) }
  let(:updated_booking_credit) { instance_double(BookingCredit, id: 1, price_cents: 1500, financial_account_id: 1, cost_center_id: 2) }
  let(:update_params) do
    {
      price: "15.00",
      financial_account_id: 1,
      cost_center_id: 2
    }.stringify_keys
  end

  describe '.call' do
    before do
      allow(BookingCredit).to receive(:find) { booking_credit }
      allow(booking_credit).to receive(:invoice) { nil }
      allow(booking_credit).to receive(:update) { true }
    end

    it 'finds the booking_credit' do
      context = described_class.call(params: update_params, booking_credit_id: booking_credit.id)

      expect(BookingCredit).to have_received(:find)
    end

    it 'updates the attributes' do
      context = described_class.call(params: update_params, booking_credit_id: booking_credit.id)

      expect(booking_credit).to have_received(:update).with(update_params)
    end

    context 'with failure' do
      before do
        allow(booking_credit).to receive(:update) { false }
        allow(booking_credit).to receive_message_chain(:errors, :full_messages) { 'error_message' }
      end

      it 'is a failure and shows the error message' do
        context = described_class.call(params: update_params, booking_credit_id: booking_credit.id)

        expect(context).to be_a_failure
      end

      it 'shows the error message' do
        context = described_class.call(params: update_params, booking_credit_id: booking_credit.id)

        expect(context.message).to eq('error_message')
      end
    end
  end
end
