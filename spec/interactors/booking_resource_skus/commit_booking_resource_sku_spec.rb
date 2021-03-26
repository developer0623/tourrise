require 'rails_helper'

RSpec.describe BookingResourceSkus::CommitBookingResourceSku, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku) { instance_double(BookingResourceSku, resource_sku: resource_sku, resource_sku_snapshot: { 'name' => 'resource_sku_name' }) }
    let(:resource_sku) { instance_double(ResourceSku) }
    let(:booking_resource_sku_service) { instance_double(BookingResourceSkuService) }
    let(:booking_resource_sku_availability) { instance_double(BookingResourceSkuAvailability) }

    let(:call_params) do
      {
        booking_resource_sku: booking_resource_sku
      }
    end

    before do
      allow(BookingResourceSkuService).to receive(:new) { booking_resource_sku_service }
      allow(booking_resource_sku).to receive(:booking_resource_sku_availability) { booking_resource_sku_availability }
      allow(booking_resource_sku_service).to receive(:bookable?) { true }
      allow(BookingResourceSkuAvailabilities::CommitBookingResourceSkuAvailability).to receive(:call) { true }
    end

    it 'initializes a booking resource sku service' do
      described_class.call(call_params)

      expect(BookingResourceSkuService).to have_received(:new).with(booking_resource_sku)
    end

    it 'checks if the resource sku is available for the booking resource sku' do
      described_class.call(call_params)

      expect(booking_resource_sku_service).to have_received(:bookable?).with(no_args)
    end

    context 'when the booking resource sku is available' do
      it 'is a success' do
        context = described_class.call(call_params)

        expect(context).to be_success
      end
    end

    context 'when a resource sku has been deleted' do
      let(:resource_sku) { nil }

      it 'is a failure' do
        context = described_class.call(call_params)

        expect(context).to be_failure
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq(I18n.t("bookings.check_booking_resource_skus_availability.resource_sku_missing", name: "resource_sku_name"))
      end
    end

    context 'when a booking resource sku is not available anymore' do
      before do
        allow(booking_resource_sku_service).to receive(:bookable?) { false }
      end

      it 'is a failure' do
        context = described_class.call(call_params)

        expect(context).to be_failure
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq(I18n.t("bookings.check_booking_resource_skus_availability.not_available", name: "resource_sku_name"))
      end
    end
  end
end
