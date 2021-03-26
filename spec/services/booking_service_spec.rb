require 'rails_helper'

RSpec.describe BookingService, type: :service do
  subject(:service) { BookingService.new(booking) }

  let(:booking) { instance_double(Booking) }

  describe '#offer_creatable?' do
    let(:booking_offers_service) { instance_double(BookingOffersService) }

    before do
      allow(BookingOffersService).to receive(:new) { booking_offers_service }
      allow(booking_offers_service).to receive(:offer_creatable?)
    end

    it 'delegates the call to the booking_offers_service' do
      service.offer_creatable?

      expect(booking_offers_service).to have_received(:offer_creatable?).with(no_args)
    end
  end

  describe '#offer_available?' do
    let(:booking_offers_service) { instance_double(BookingOffersService) }

    before do
      allow(BookingOffersService).to receive(:new) { booking_offers_service }
      allow(booking_offers_service).to receive(:offer_available?)
    end

    it 'delegates the call to the booking_offers_service' do
      service.offer_available?

      expect(booking_offers_service).to have_received(:offer_available?).with(no_args)
    end
  end

  describe '#invoice_creatable?' do
    let(:booking_invoices_service) { instance_double(BookingInvoicesService) }

    before do
      allow(BookingInvoicesService).to receive(:new) { booking_invoices_service }
      allow(booking_invoices_service).to receive(:invoice_creatable?)
    end

    it 'delegates the call to the booking_offers_service' do
      service.invoice_creatable?

      expect(booking_invoices_service).to have_received(:invoice_creatable?).with(no_args)
    end
  end

  describe '#invoice_available?' do
    let(:booking_invoices_service) { instance_double(BookingInvoicesService) }

    before do
      allow(BookingInvoicesService).to receive(:new) { booking_invoices_service }
      allow(booking_invoices_service).to receive(:invoice_available?)
    end

    it 'delegates the call to the booking_offers_service' do
      service.invoice_available?

      expect(booking_invoices_service).to have_received(:invoice_available?).with(no_args)
    end
  end

  describe "#committable" do
    let(:booking) { instance_double(Booking) }

    let(:booking_invoices_service) { instance_double(BookingInvoicesService) }

    subject(:committable) { described_class.new(booking).committable? }

    before do
      allow(BookingInvoicesService).to receive(:new) { booking_invoices_service }
      allow(booking_invoices_service).to receive(:invoice_available?) { true }
    end

    context 'when the booking is not in the right state' do
      before do
        allow(booking).to receive(:may_commit?) { false }
      end

      it { is_expected.to be(false) }
    end

    context "when the booking is in the right state" do
      before do
        allow(booking).to receive(:may_commit?) { true }
        allow(booking).to receive(:booking_invoices) { ['one'] }
      end

      it { is_expected.to be(true) }
    end
  end
end
