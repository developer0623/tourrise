require 'rails_helper'

RSpec.describe Bookings::ChangeSecondaryState, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double("Booking") }
    let(:booking_invoices) { instance_double("BookingInvoices") }
    let(:booking_offers) { instance_double("BookingOffers") }
    let(:booking_service) { instance_double("BookingService") }

    before do
      allow(booking).to receive(:update_attribute)
      allow(booking).to receive(:in_progress?) { true }
      allow(booking).to receive(:valid?) { true }
      allow(booking).to receive(:booking_invoices) { booking_invoices }
      allow(booking).to receive(:booking_offers) { booking_offers }
      allow(BookingService).to receive(:new) { booking_service }
    end

    context 'when booking is not in progress' do
      before do
        allow(booking).to receive(:in_progress?) { false }
      end

      it 'resets the secondary state' do
        described_class.call(booking: booking)

        expect(booking).to have_received(:update_attribute).with(:secondary_state, nil)
      end
    end

    context 'when no invoice or offer exists' do
      before do
        allow(booking_service).to receive(:invoice_available?) { false }
        allow(booking_service).to receive(:offer_available?) { false }
      end

      it 'sets the secondary state to offer_missing' do
        described_class.call(booking: booking)

        expect(booking).to have_received(:update_attribute).with(:secondary_state, :offer_missing)
      end
    end

    context 'when no invoice but an offer exists' do
      before do
        allow(booking_service).to receive(:invoice_available?) { false }
        allow(booking_service).to receive(:offer_available?) { true }
      end

      it 'sets the secondary state to offer_sent' do
        described_class.call(booking: booking)

        expect(booking).to have_received(:update_attribute).with(:secondary_state, :offer_sent)
      end
    end

    context 'when an invoice exists' do
      before do
        allow(booking_service).to receive(:invoice_available?) { true }
      end

      it 'sets the secondary state to invoice_sent' do
        described_class.call(booking: booking)

        expect(booking).to have_received(:update_attribute).with(:secondary_state, :invoice_sent)
      end
    end

    context 'when the booking could not be saved' do
      before do
        allow(booking).to receive(:valid?) { false }
        allow(booking_service).to receive(:invoice_available?) { false }
        allow(booking_service).to receive(:offer_available?) { false }
        allow(booking).to receive(:errors) { double(:errors, full_messages: "error_messages") }
      end

      it 'show the error message' do
        context = described_class.call(booking: booking)

        expect(context).not_to be_success
        expect(context.message).to eq("error_messages")
      end
    end
  end
end
