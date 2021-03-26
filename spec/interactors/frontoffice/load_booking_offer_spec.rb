# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frontoffice::LoadBookingOffer, type: :interactor do
  let(:booking) { instance_double('Booking', scrambled_id: 'scrambled_id') }
  let(:booking_offers) { instance_double('BookingOffers') }
  let(:booking_offer) { instance_double('BookingOffer', scrambled_id: 'booking_offer_id') }

  before do
    allow(Booking).to receive(:find_by) { booking }
    allow(booking).to receive(:booking_offers) { booking_offers }
  end

  subject(:context) { described_class.call(booking_scrambled_id: 'scrambled_id', offer_scrambled_id: booking_offer.scrambled_id) }

  describe '.call' do
    context 'when booking and offer exists' do
      before do
        allow(booking_offers).to receive(:find_by) { booking_offer }
      end

      it 'finds the booking by its scrambled id' do
        expect(context).to be_a_success

        expect(Booking).to have_received(:find_by).with(scrambled_id: 'scrambled_id')
      end

      it 'finds the booking offer by its id' do
        expect(context).to be_a_success

        expect(booking_offers).to have_received(:find_by).with(scrambled_id: "booking_offer_id")
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the booking_offer' do
        expect(context.booking_offer).to eq(booking_offer)
      end
    end

    context 'when booking exists, but no matching offer' do
      before do
        allow(booking_offers).to receive(:find_by) { nil }
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides the error message' do
        expect(context.message).to eq(:not_found)
      end
    end

    context 'when no booking exists' do
      before do
        allow(Booking).to receive(:find_by) { nil }
      end

      it 'fails' do
        expect(context).to be_a_failure
      end

      it 'provides the error message' do
        expect(context.message).to eq(:not_found)
      end
    end
  end
end
