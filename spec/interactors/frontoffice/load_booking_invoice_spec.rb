# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frontoffice::LoadBookingInvoice, type: :interactor do
  let(:booking) { instance_double('Booking', scrambled_id: 'scrambled_id') }
  let(:booking_invoices) { class_double('BookingInvoice') }
  let(:booking_invoice) { instance_double('BookingInvoice', scrambled_id: 'booking_invoice_id') }

  before do
    allow(Booking).to receive(:find_by) { booking }
    allow(booking).to receive(:booking_invoices) { booking_invoices }
  end

  subject(:context) { described_class.call(booking_scrambled_id: 'scrambled_id', invoice_scrambled_id: booking_invoice.scrambled_id) }

  describe '.call' do
    context 'existing booking and invoice' do
      before do
        allow(booking_invoices).to receive(:find_by) { booking_invoice }
      end

      it 'finds the booking by its scrambled id' do
        expect(context).to be_a_success

        expect(Booking).to have_received(:find_by).with(scrambled_id: 'scrambled_id')
      end

      it 'finds the booking invoice by its id' do
        expect(context).to be_a_success

        expect(booking_invoices).to have_received(:find_by).with(scrambled_id: 'booking_invoice_id')
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides the booking_invoice' do
        expect(context.booking_invoice).to eq(booking_invoice)
      end
    end

    context 'existing booking, no matching invoice' do
      before do
        allow(booking_invoices).to receive(:find_by) { nil }
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
