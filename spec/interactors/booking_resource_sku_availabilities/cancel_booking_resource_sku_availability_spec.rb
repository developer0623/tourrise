require 'rails_helper'

RSpec.describe BookingResourceSkuAvailabilities::CancelBookingResourceSkuAvailability, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku_availability) do
      instance_double(BookingResourceSkuAvailability, attributes: attributes)
    end

    let(:attributes) do
      {
        'booking_by_id' => 'current_booked_by_id',
        'booked_at' => 'current_booked_at'
      }
    end

    before do
      allow(booking_resource_sku_availability).to receive(:update) { true }
    end

    subject(:context) { described_class.call(booking_resource_sku_availability: booking_resource_sku_availability) }

    it { is_expected.to be_success }

    it 'resets the booked_by and booked_at columns' do
      described_class.call(booking_resource_sku_availability: booking_resource_sku_availability)

      expect(booking_resource_sku_availability).to have_received(:update).with(
        booked_by_id: nil,
        booked_at: nil
      )
    end

    context 'when the update fails' do
      let(:errors) { instance_double(ActiveModel::Errors, full_messages: 'error_messages') }

      before do
        allow(booking_resource_sku_availability).to receive(:update) { false }
        allow(booking_resource_sku_availability).to receive(:errors) { errors }
      end

      it { is_expected.to be_failure }

      it 'sets the error message' do
        expect(context.message).to eq('error_messages')
      end
    end
  end

  describe '.rollback' do
    let(:booking_resource_sku_availability) { instance_double(BookingResourceSkuAvailability) }

    let(:attributes) do
      {
        'booked_by_id' => 'current_booked_by_id',
        'booked_at' => 'current_booked_at'
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
        'booked_by_id' => 'current_booked_by_id',
        'booked_at' => 'current_booked_at'
      )
    end
  end
end
