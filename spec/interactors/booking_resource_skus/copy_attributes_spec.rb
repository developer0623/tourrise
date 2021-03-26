require 'rails_helper'

RSpec.describe BookingResourceSkus::CopyAttributes, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku) do
      instance_double(
        BookingResourceSku,
        attributes: attributes,
        booking_attribute_values: booking_attribute_values,
        booking_resource_sku_availability: 'booking_resource_sku_availability',
        flights: ['flights']
      )
    end

    let(:new_booking_resource_sku) { instance_double(BookingResourceSku) }
    let(:attributes) { {} }
    let(:booking_attribute_values) do
      [booking_attribute_value]
    end
    let(:booking_attribute_value) { instance_double(BookingAttributeValue, attributes: {}) }
    let(:duplicated_booking_attribute_value) { instance_double(BookingAttributeValue, attributes: {}) }
    let(:call_params) do
      { 
        booking_resource_sku: booking_resource_sku,
        new_booking_resource_sku: new_booking_resource_sku
      }
    end

    before do
      allow(new_booking_resource_sku).to receive(:attributes=)
      allow(new_booking_resource_sku).to receive(:booking_attribute_values=)
      allow(new_booking_resource_sku).to receive(:flights=)
      allow(new_booking_resource_sku).to receive(:booking_resource_sku_availability=)
      allow(new_booking_resource_sku).to receive(:save) { true }
      allow(BookingAttributeValue).to receive(:new) { duplicated_booking_attribute_value }
    end

    it 'assigns the duplicated attributes to the new booking resource sku' do
      described_class.call(call_params)

      expect(new_booking_resource_sku).to have_received(:attributes=).with({})
    end

    it 'copies the booking attribute values' do
      described_class.call(call_params)

      expect(new_booking_resource_sku).to have_received(:booking_attribute_values=).with([duplicated_booking_attribute_value])
    end

    it 'copies the availability' do
      described_class.call(call_params)

      expect(new_booking_resource_sku).to have_received(:booking_resource_sku_availability=).with('booking_resource_sku_availability')
    end

    it 'copies the flights' do
      described_class.call(call_params)

      expect(new_booking_resource_sku).to have_received(:flights=).with(['flights'])
    end

  end
end
