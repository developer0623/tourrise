# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingCredits::CreateBookingCredit, type: :interactor do
  let(:booking_credit) { instance_double(BookingCredit) }
  let(:booking) { instance_double(Booking, id: 'booking_id') }
  let(:create_params) do
    {
      name: "Deposit",
      price: "10.00",
      financial_account_id: 1,
      cost_center_id: 1
    }.stringify_keys
  end

  describe '.call' do
    before do
      allow(Booking).to receive(:find) { booking }
      allow(booking).to receive_message_chain(:booking_credits, :new) { booking_credit }
      allow(BookingCredit).to receive(:new) { booking_credit }
      allow(booking_credit).to receive(:assign_attributes)
      allow(booking_credit).to receive(:save) { true }
    end

    it 'initializes a new booking_credit' do
      described_class.call(params: create_params, booking_id: booking.id)

      expect(booking.booking_credits).to have_received(:new)
    end

    it 'assigns the attributes' do
      described_class.call(params: create_params, booking_id: booking.id)

      assigned_params = {
        "name" => "Deposit",
        "price" => "10.00",
        "financial_account_id" => 1,
        "cost_center_id" => 1
      }
      expect(booking_credit).to have_received(:assign_attributes).with(assigned_params)
    end

    context 'with failure' do
      before do
        allow(booking_credit).to receive(:save) { false }
        allow(booking_credit).to receive_message_chain(:errors, :full_messages) { 'error_message' }
      end

      it 'is a failure' do
        context = described_class.call(params: create_params, booking_id: booking.id)

        expect(context).to be_a_failure
      end

      it 'shows the error message' do
        context = described_class.call(params: create_params, booking_id: booking.id)

        expect(context.message).to eq('error_message')
      end
    end
  end
end
