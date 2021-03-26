require 'rails_helper'

describe Easybill::BookingCanceledHandler, type: :handler do
  let(:booking_data) { 'data' }

  before do
    allow(Easybill::CancelInvoicesJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a cancel invoices job' do
      described_class.handle(booking_data)

      expect(Easybill::CancelInvoicesJob).to have_received(:perform_later).with('data')
    end
  end
end
