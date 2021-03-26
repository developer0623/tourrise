require 'rails_helper'

RSpec.describe BookingResourceSkus::AssignAvailability, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double(Booking, booked?: false) }
    let(:resource_sku) { instance_double(ResourceSku) }
    let(:booking_resource_sku) { instance_double(BookingResourceSku, required_quantity: "required_quantity", starts_on: "starts_on", ends_on: "ends_on") }
    let(:resource_sku_availability_service) { instance_double(ResourceSkuAvailabilityService) }
    let(:availability) { instance_double(Availability, present?: true) }

    let(:call_params) do
      {
        booking: booking,
        resource_sku: resource_sku,
        booking_resource_sku: booking_resource_sku
      }
    end

    before do
      allow(ResourceSkuAvailabilityService).to receive(:new) { resource_sku_availability_service }
      allow(resource_sku_availability_service).to receive(:find_bookable_availability_by_score) { availability }
      allow(resource_sku_availability_service).to receive(:needs_availability?) { true }
      allow(booking_resource_sku).to receive(:availability=)
    end

    it 'initializes a resource sku availability service' do
      described_class.call(call_params)

      expect(ResourceSkuAvailabilityService).to have_received(:new).with(resource_sku)
    end

    it 'looks for the first bookable availability' do
      described_class.call(call_params)

      expect(resource_sku_availability_service).to have_received(:find_bookable_availability_by_score).with("required_quantity", "starts_on", "ends_on")
    end

    it 'assigns the first available availability to the booking_resource_sku' do
      described_class.call(call_params)

      expect(booking_resource_sku).to have_received(:availability=).with(availability)
    end

    it 'sets the success context' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end

    context 'with fail_on_unavailability context set' do
      before do
        allow(resource_sku_availability_service).to receive(:find_bookable_availability_by_score) { nil }
      end

      it 'sets the failure context' do
        context = described_class.call(call_params.merge(fail_on_unavailability: true))

        expect(context).to be_failure
      end

      it 'sets an error message' do
        context = described_class.call(call_params.merge(fail_on_unavailability: true))

        expect(context.message).to be
      end
    end

    context 'when no inventory is defined' do 
      before do
        allow(resource_sku_availability_service).to receive(:needs_availability?) { false }
      end

      it 'sets the success context' do
        context = described_class.call(call_params)

        expect(context).to be_success
      end
    end

    context 'when the resorce sku ist not available' do
      before do
        allow(resource_sku_availability_service).to receive(:find_bookable_availability_by_score) { nil }
      end

      it 'it not assigning anything' do
        described_class.call(call_params)

        expect(booking_resource_sku).not_to have_received(:availability=)
      end
    end

    context 'when the booking is already booked' do
      let(:booking) { instance_double(Booking, booked?: true) }

      before do
       allow(BookingResourceSkus::CommitBookingResourceSku).to receive(:call)
      end

      it 'commits the booking resource sku' do
        context = described_class.call(call_params)

        expect(BookingResourceSkus::CommitBookingResourceSku).to have_received(:call).with(context)
      end
    end
  end
end

