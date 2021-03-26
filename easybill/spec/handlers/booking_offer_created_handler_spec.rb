require 'rails_helper'

describe Easybill::BookingOfferCreatedHandler, type: :handler do
  let(:booking_offer_data) { 'data' }

  before do
    allow(Easybill::CreateOfferJob).to receive(:perform_later)
  end

  describe '.handle' do
    it 'queues a create offer job' do
      described_class.handle(booking_offer_data)

      expect(Easybill::CreateOfferJob).to have_received(:perform_later).with('data')
    end
  end
end
