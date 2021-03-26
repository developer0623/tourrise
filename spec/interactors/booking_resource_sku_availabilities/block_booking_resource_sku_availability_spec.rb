require 'rails_helper'

RSpec.describe BookingResourceSkuAvailabilities::BlockBookingResourceSkuAvailability, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku_availability) do
      instance_double(BookingResourceSkuAvailability)
    end

    before do
      travel_to(Time.local(1987))
      allow(booking_resource_sku_availability).to receive(:update) { true }
    end

    after do
      travel_back
    end

    subject(:context) { described_class.call(booking_resource_sku_availability: booking_resource_sku_availability, user_id: 'user_id') }

    it 'sets the blocked_by and blocked_at columns' do
      context

      expect(booking_resource_sku_availability).to have_received(:update).with(
        blocked_by_id: 'user_id',
        blocked_at: Time.zone.now
      )
    end

    it { is_expected.to be_success }
  end

  describe '.rollback' do
    let(:booking_resource_sku_availability) { instance_double(BookingResourceSkuAvailability) }

    subject(:interactor) { described_class.new(booking_resource_sku_availability: booking_resource_sku_availability) }

    before do
      allow(BookingResourceSkuAvailability).to receive(:find_by_id) { booking_resource_sku_availability }
      allow(booking_resource_sku_availability).to receive(:update)
    end

    it 'clears the blocked by and blocked at columns' do
      interactor.memoized_booking_resource_sku_availability = booking_resource_sku_availability

      interactor.rollback

      expect(booking_resource_sku_availability).to have_received(:update).with(
        blocked_by_id: nil,
        blocked_at: nil
      )
    end
  end
end
