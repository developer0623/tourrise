require 'rails_helper'

RSpec.describe BookingResourceSkus::AssignBookingResourceSkuAttributes, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku) { instance_double(BookingResourceSku) } 
    let(:booking) { instance_double(Booking, people_count: nil) } 
    let(:resource_type) { instance_double(ResourceType, handle: 'handle', with_date_range?: false) }
    let(:resource_sku) { instance_double(ResourceSku, resource_type: resource_type, allow_partial_payment: true) }
    let(:request_params) do
      {
        'id' => 'booking_id',
        'booking_resource_sku' => {
          'price' => 'resource_sku_price'
        }
      }
    end

    let(:call_params) do
      {
        booking_resource_sku: booking_resource_sku,
        booking: booking,
        resource_sku: resource_sku,
        params: request_params
      }
    end

    before do
      allow(booking_resource_sku).to receive(:assign_attributes)
      allow(booking_resource_sku).to receive(:allow_partial_payment=)
      allow(booking_resource_sku).to receive(:booking_attribute_values_attributes=)
      allow(booking_resource_sku).to receive(:booking_attribute_values) { [] }
    end

    context 'when the booking resource sku is missing' do
      it 'fails with an error message' do
        context = described_class.call

        expect(context).to be_failure
        expect(context.message).to eq(I18n.t("booking_resource_skus.assign_booking_resource_sku_attributes.booking_resource_sku_missing"))
      end
    end

    it 'assigns the basic attributes' do
      described_class.call(call_params)

      expect(booking_resource_sku).to have_received(:assign_attributes).with(
        booking: booking,
        resource_sku: resource_sku,
        quantity: 1,
        price: 'resource_sku_price'
      )
    end

    it 'copies the allow_partial_payment attribute from the resource_sku' do
      described_class.call(call_params)

      expect(booking_resource_sku).to have_received(:allow_partial_payment=).with(true)
    end

    context 'with participants' do
      let(:request_params) do
        {
          'id' => 'booking_id',
          'booking_resource_sku' => {
            'price' => 'resource_sku_price',
            'participant_ids' => %w[participant_id1 participant_id2]
          }
        }
      end

      before do
        allow(booking_resource_sku).to receive(:participant_ids=)
      end

      it 'assigns the participant ids' do
        described_class.call(call_params)

        expect(booking_resource_sku).to have_received(:participant_ids=).with(['participant_id1', 'participant_id2'])
      end

    end

    context 'with flight data associated to the resource_sku' do
      let(:resource_type) { instance_double(ResourceType, handle: 'flight', with_date_range?: false) }
      let(:flight_ids) { 'flight_ids' }
      let(:flights) { double(:flights, pluck: flight_ids ) }

      before do
        allow(resource_sku).to receive(:flights) { flights }
        allow(booking_resource_sku).to receive(:flight_ids=)
      end

      it 'copies data from the resource sku' do
        described_class.call(call_params)

        expect(booking_resource_sku).to have_received(:flight_ids=).with('flight_ids')
      end
    end

    it 'sets the success context' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end
  end
end
