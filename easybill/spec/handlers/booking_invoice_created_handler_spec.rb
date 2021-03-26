require 'rails_helper'

describe Easybill::BookingInvoiceCreatedHandler, type: :handler do
  let(:booking_invoice_data) { 'data' }

  before do
    allow(Easybill::CreateInvoiceJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a create invoice job' do
      described_class.handle(booking_invoice_data)

      expect(Easybill::CreateInvoiceJob).to have_received(:perform_later).with('data')
    end
  end
end
