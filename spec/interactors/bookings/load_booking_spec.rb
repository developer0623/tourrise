# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::LoadBooking, type: :interactor do
  subject(:context) { described_class.call(booking_id: booking.id) }

  let(:booking) { instance_double('Bookings::Booking', id: 1) }

  describe '.call' do
    context 'existing booking' do
      before do
        allow(Booking).to receive(:find_by_id)
          .with(booking.id)
          .and_return(booking)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the booking' do
        expect(context.booking).to eq(booking)
      end
    end

    context 'when the booking doesn\'t exist' do
      before do
        allow(Booking).to receive(:find_by_id)
          .with(booking.id)
          .and_return(nil)
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides a failure message' do
        expect(context.message).to be_present
      end
    end
  end
end
