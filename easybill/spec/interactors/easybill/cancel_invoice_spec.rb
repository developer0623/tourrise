# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Easybill::CancelInvoice, type: :interactor do
  describe '.call' do
    let(:invoice_id) { 123 }
    let(:easybill_document_id) { 'geilesDokument' }
    let(:invoice) { instance_double('Easybill::Invoice', external_id: easybill_document_id) }
    let(:easybill_service) { instance_double('Easybill::ApiService') }
    let(:document_response) { double(:response, success?: true) }

    before do
      allow(invoice).to receive(:cancel!)
    end

    it 'updates the invoice' do
      described_class.call(invoice: invoice)

      expect(invoice).to have_received(:cancel!)
    end

    it 'reloads the invoice context' do
      context = described_class.call(invoice: invoice)

      expect(context.invoice).to eq(invoice)
    end

    it 'is a success' do
      context = described_class.call(invoice: invoice)

      expect(context).to be_a_success
    end
  end
end
