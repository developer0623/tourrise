# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::UpdateBooking do
  let(:booking) { instance_double(Booking, id: 'booking_id', attributes: booking_attributes, in_progress?: false, participants: participants) }
  let(:participants) { [participant] }
  let(:participant) { instance_double(Participant, first_name: "foo", last_name: "bar", 'placeholder=': true) }
  let(:booking_attributes) { 'booking_attributes' }

  let(:booking_params) do
    {
      customer_id: 2
    }
  end

  describe '#call' do
    before do
      allow(Booking).to receive(:find) { booking }
      allow(booking).to receive(:assign_attributes)
      allow(booking).to receive(:may_process?) { false }
      allow(booking).to receive(:ends_on_changed?) { false }
      allow(booking).to receive(:starts_on_changed?) { false }
      allow(booking).to receive(:product_sku_id_changed?) { false }
      allow(booking).to receive(:save) { true }
    end

    context 'success' do
      it 'loads the booking' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        expect(Booking).to have_received(:find).with('booking_id')
      end

      it 'updates a booking' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        expect(context).to be_success
      end

      it 'updates the fields' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        booking = context.booking

        expect(booking).to have_received(:assign_attributes).with(customer_id: 2)
      end
    end

    context 'when the booking is in progress' do
      let(:booking) { instance_double(Booking, id: 'booking_id', attributes: booking_attributes, in_progress?: true) }
      let(:booking_in_progress) { instance_double(BookingInProgress, participants: participants) }

      before do
        allow(BookingInProgress).to receive(:find) { booking_in_progress }
        allow(booking_in_progress).to receive(:assign_attributes)
        allow(booking_in_progress).to receive(:save) { true }
      end

      it 'initializes a BookingInProgress instance' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        expect(BookingInProgress).to have_received(:find).with('booking_id')
      end

      it 'updates the fields' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        expect(booking_in_progress).to have_received(:assign_attributes).with(customer_id: 2)
      end
    end

    context 'with incomplete participants' do
      let(:participant) { instance_double(Participant, first_name: nil, last_name: "bar") }

      before do
        allow(participant).to receive(:placeholder=) { true }
      end

      it 'marks the participant as placeholder' do
        context = described_class.call(
          booking_id: booking.id,
          params: booking_params
        )

        expect(participant).to have_received(:placeholder=).with(true)
      end
    end
  end
end
