# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::DownloadOffer, type: :interactor do
  describe '.call' do
    let(:offer_id) { 123 }
    let(:easybill_document_id) { 'geilesDokument' }
    let(:easybill_offer) { instance_double('Easybill::Offer', external_id: easybill_document_id) }
    let(:easybill_service) { instance_double('Easybill::ApiService') }
    let(:document_response) { 'a_pdf_file' }

    before do
      allow(Easybill::Offer).to receive(:find_by) { easybill_offer }
      allow(Easybill::BookingMapper).to receive(:to_easybill_document) { easybill_document_data }
      allow(Easybill::ApiService).to receive(:new) { easybill_service }
      allow(easybill_service).to receive(:download_document) { document_response }
    end

    it 'loads the offer' do
      described_class.call(offer_id: offer_id)

      expect(Easybill::Offer).to have_received(:find_by).with(id: 123)
    end

    it 'initializes an easybill api service' do
      described_class.call(offer_id: offer_id)

      expect(Easybill::ApiService).to have_received(:new).with(no_args)
    end

    it 'downloads the document' do
      described_class.call(offer_id: offer_id)

      expect(easybill_service).to have_received(:download_document).with('geilesDokument')
    end

    it 'sets the context' do
      context = described_class.call(offer_id: offer_id)

      expect(context.document).to eq('a_pdf_file')
    end

    context 'when the easybill offer does not exist' do
      before do
        allow(Easybill::Offer).to receive(:find_by) { nil }
      end

      it 'sets a failure context' do
        context = described_class.call(offer_id: offer_id)

        expect(context).to be_a_failure
      end

      it 'has an error message' do
        context = described_class.call(offer_id: offer_id)

        expect(context.message).to eq(:offer_not_found)
      end
    end

    context 'when the download fails' do
      before do
        allow(easybill_service).to receive(:download_document) { nil }
      end

      it 'sets a failure context' do
        context = described_class.call(offer_id: offer_id)

        expect(context).to be_a_failure
      end

      it 'has an error message' do
        context = described_class.call(offer_id: offer_id)

        expect(context.message).to eq(:document_not_found)
      end
    end
  end
end
