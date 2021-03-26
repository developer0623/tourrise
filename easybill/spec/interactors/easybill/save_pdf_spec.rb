# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::SavePdf, type: :interactor do
  describe '.call' do
    let(:easybill_document_id) { 'geilesDokument' }
    let(:easybill_service) { instance_double('Easybill::ApiService') }
    let(:document_response) { double(:response, body: 'a_document_pdf', success?: true) }
    let(:error_response) { double(:response, body: "error", success?: false) }
    let(:pdf) { double(:pdf) }
    let(:booking) do
      instance_double('Booking', assignee_id: 'assignee_id' )
    end
    let(:booking_offer) { double(:booking_offer, pdf: pdf) }
    let(:params) {{ document_id: easybill_document_id, attachable: booking_offer, booking: booking }}

    before do
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:download_document) { document_response }
      allow(pdf).to receive(:attach) { true }
      allow(StringIO).to receive(:new) { 'stream' }
    end

    it 'initializes an easybill api service' do
      described_class.call(params)

      expect(Easybill::ApiService).to have_received(:new)
    end

    it 'downloads the document' do
      described_class.call(params)

      expect(easybill_service).to have_received(:download_document).with('geilesDokument')
    end

    it 'attach the document' do
      described_class.call(params)

      expect(pdf).to have_received(:attach)
                         .with(io: 'stream',
                               filename: "#{booking_offer.class.name.underscore}_#{easybill_document_id}.pdf",
                               content_type: "application/pdf")
    end

    context 'when the easybill customer does not exist' do
      before do
        allow(easybill_service).to receive(:download_document) { error_response }
      end

      it 'sets a failure context' do
        context = described_class.call(params)

        expect(context.failure?).to be(true)
      end

      it 'returns the error message' do
        context = described_class.call(params)

        expect(context.message).to eq("error")
      end
    end
  end
end
