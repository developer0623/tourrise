require 'rails_helper'

RSpec.describe BookingResourceSkus::DuplicateBookingResourceSku, type: :interactor do
  describe '.call' do
    before do
      allow(BookingResourceSku).to receive(:new)
      allow(Bookings::LoadBooking).to receive(:call!) { true }
      allow(BookingResourceSkus::LoadBookingResourceSku).to receive(:call!) { true }
      allow(BookingResourceSkus::CopyAttributes).to receive(:call!) { true }
    end

    it 'initializes a new booking resource sku' do
      described_class.call

      expect(BookingResourceSku).to have_received(:new)
    end
  end

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      Bookings::LoadBooking,
      BookingResourceSkus::LoadBookingResourceSku,
      BookingResourceSkus::CopyAttributes
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end
end
