require 'rails_helper'

RSpec.describe BookingResourceSkus::UpdateBookingResourceSku, type: :interactor do
  describe '.call' do
    before do
      allow(Bookings::LoadBooking).to receive(:call!) { true }
      allow(BookingResourceSkus::LoadBookingResourceSku).to receive(:call!) { true }
      allow(BookingResourceSkus::UpdateBookingResourceSkuAttributes).to receive(:call!) { true }
      allow(BookingResourceSkus::UpdateAvailability).to receive(:call!) { true }
      allow(BookingResourceSkus::SaveBookingResourceSku).to receive(:call!) { true }
      allow(Bookings::ChangeSecondaryState).to receive(:call!) { true }
    end

    it 'succeeds' do
      context = described_class.call

      expect(context).to be_success
    end
  end

  it 'organizes the correct interactors' do
    expected_organized_classes = [
      Bookings::LoadBooking,
      BookingResourceSkus::LoadBookingResourceSku,
      BookingResourceSkus::UpdateBookingResourceSkuAttributes,
      BookingResourceSkus::UpdateAvailability,
      BookingResourceSkus::SaveBookingResourceSku,
      Bookings::ChangeSecondaryState
    ]

    expect(described_class.organized).to eq(expected_organized_classes)
  end
end
