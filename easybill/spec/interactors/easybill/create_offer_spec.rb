# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CreateOffer, type: :interactor do
  describe '.call' do
    let(:booking_offer_data) do
      {
        'id' => 'booking_offer_id',
        'booking_id' => 123,
        "number" => "123"
      }
    end
    let(:customer_id) { 'a_customer_id' }
    let(:booking) do
      instance_double('Booking', customer_id: customer_id, assignee_id: 'assignee_id')
    end
    let(:easybill_document_data) { {} }
    let(:easybill_service) { instance_double(Easybill::ApiService) }
    let(:easybill_customer) { instance_double(Easybill::Customer) }
    let(:easybill_employee) { instance_double(Easybill::Employee, api_key: 'api_key') }
    let(:booking_mapper) { instance_double(Easybill::BookingMapper) }
    let(:document_response) { double(:document_response, success?: true) }
    let(:booking_offer) { double(:booking_offer) }
    let(:sav_pdf_context) { double(:context, success?: true) }

    before do
      allow(Booking).to receive(:find) { booking }
      allow(BookingOffer).to receive(:find) { booking_offer }
      allow(Easybill::BookingMapper).to receive(:to_easybill_document) { easybill_document_data }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:create_document) { document_response }
      allow(easybill_service).to receive(:complete_document) { document_response }
      allow(Easybill::Offer).to receive(:create!) { Easybill::Offer.new }
      allow(document_response).to receive(:[]).with('id').and_return('document_id')
      allow(document_response).to receive(:[]).with('number').and_return('number')
      allow(Easybill::Customer).to receive(:find_by) { easybill_customer }
      allow(Easybill::Employee).to receive(:find_by) { easybill_employee }
      allow(Easybill::SavePdf).to receive(:call) { sav_pdf_context }
    end

    it 'checks if the easybill customer exists' do
      described_class.call(data: booking_offer_data)

      expect(Easybill::Customer).to have_received(:find_by).with(customer_id: 'a_customer_id')
    end

    it 'initializes the api service' do
      described_class.call(data: booking_offer_data)

      expect(Easybill::ApiService).to have_received(:new).with(api_key: 'api_key')
    end

    it 'loads the current assignee' do
      described_class.call(data: booking_offer_data)

      expect(Easybill::Employee).to have_received(:find_by).with(user_id: 'assignee_id')
    end

    it 'loads the booking' do
      described_class.call(data: booking_offer_data)

      expect(Booking).to have_received(:find).with(123)
    end

    it 'loads the booking_offer' do
      described_class.call(data: booking_offer_data)

      expect(BookingOffer).to have_received(:find).with('booking_offer_id')
    end

    it 'maps the booking to easybill data' do
      described_class.call(data: booking_offer_data)

      expect(Easybill::BookingMapper).to have_received(:to_easybill_document).with(booking, booking_offer, type: 'OFFER')
    end

    it 'calls the easybill service to create the offer document' do
      described_class.call(data: booking_offer_data)

      expect(easybill_service).to have_received(:create_document).with(easybill_document_data)
    end

    it 'calls the easybill service to complete the offer document' do
      described_class.call(data: booking_offer_data)

      expect(easybill_service).to have_received(:complete_document).with('document_id')
    end

    it 'creates the easybill document offer sync entry' do
      described_class.call(data: booking_offer_data)

      expect(Easybill::Offer).to have_received(:create!).with(
        booking_offer_id: 'booking_offer_id',
        external_id: 'document_id',
        external_number: 'number'

      )
    end

    context 'when the easybill customer does not exist' do
      before do
        allow(Easybill::Customer).to receive(:find_by).and_return(nil)
      end

      it 'sets a failure context' do
        context = described_class.call(data: booking_offer_data)

        expect(context.failure?).to be(true)
      end

      it 'returns the error message' do
        context = described_class.call(data: booking_offer_data)

        expect(context.error).to eq(:easybill_customer_not_created)
      end
    end
  end
end
