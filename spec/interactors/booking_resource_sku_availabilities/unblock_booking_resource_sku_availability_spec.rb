require 'rails_helper'

RSpec.describe BookingResourceSkuAvailabilities::UnblockBookingResourceSkuAvailability, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku_availability) do
      instance_double(BookingResourceSkuAvailability, attributes: attributes)
    end

    let(:attributes) do
      {
        'blocked_by_id' => 'current_blocked_by_id',
        'blocked_at' => 'current_blocked_at'
      }
    end

    before do
      allow(booking_resource_sku_availability).to receive(:update) { true }
    end

    subject(:context) { described_class.call(booking_resource_sku_availability: booking_resource_sku_availability) }

    it 'resets the blocked_by and blocked_at columns' do
      described_class.call(booking_resource_sku_availability: booking_resource_sku_availability)

      expect(booking_resource_sku_availability).to have_received(:update).with(
        blocked_by_id: nil,
        blocked_at: nil
      )
    end

    it { is_expected.to be_success }
  end

  describe '.rollback' do
    let(:booking_resource_sku_availability) { instance_double(BookingResourceSkuAvailability) }

    let(:attributes) do
      {
        'blocked_by_id' => 'current_blocked_by_id',
        'blocked_at' => 'current_blocked_at'
      }
    end

    subject(:interactor) { described_class.new(booking_resource_sku_availability: booking_resource_sku_availability) }

    before do
      allow(BookingResourceSkuAvailability).to receive(:find_by_id) { booking_resource_sku_availability }
      allow(booking_resource_sku_availability).to receive(:update)
    end

    it 'updates the booking resource sku to the memoized state' do
      interactor.memoized_state = attributes
      interactor.memoized_booking_resource_sku_availability = booking_resource_sku_availability

      interactor.rollback

      expect(booking_resource_sku_availability).to have_received(:update).with(
        'blocked_by_id' => 'current_blocked_by_id',
        'blocked_at' => 'current_blocked_at'
      )
    end
  end
end
