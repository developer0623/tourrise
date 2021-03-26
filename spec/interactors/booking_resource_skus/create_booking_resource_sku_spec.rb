require 'rails_helper'

RSpec.describe BookingResourceSkus::CreateBookingResourceSku, type: :interactor do
  describe '.call' do
    before do
      allow(BookingResourceSku).to receive(:new)
      allow(Bookings::LoadBooking).to receive(:call!) { true }
      allow(ResourceSkus::LoadResourceSku).to receive(:call!) { true }
      allow(BookingResourceSkus::AssignBookingResourceSkuAttributes).to receive(:call!) { true }
      allow(BookingResourceSkus::AssignAvailability).to receive(:call!) { true }
      allow(BookingResourceSkus::SaveBookingResourceSku).to receive(:call!) { true }
      allow(Bookings::ChangeSecondaryState).to receive(:call!) { true }
    end

    it 'initializes a booking resource sku' do
      described_class.call

      expect(BookingResourceSku).to have_received(:new)
    end
  end

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      Bookings::LoadBooking,
      ResourceSkus::LoadResourceSku,
      BookingResourceSkus::AssignBookingResourceSkuAttributes,
      BookingResourceSkus::AssignAvailability,
      BookingResourceSkus::SaveBookingResourceSku,
      Bookings::ChangeSecondaryState
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end
end
