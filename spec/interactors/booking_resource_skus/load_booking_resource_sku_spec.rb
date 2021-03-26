require 'rails_helper'

RSpec.describe BookingResourceSkus::LoadBookingResourceSku, type: :interactor do
  describe '.call' do
    let(:call_params) do
      {
        booking_resource_sku_id: 'booking_resource_sku_id'
      }
    end
    let(:booking_resource_sku) { instance_double(BookingResourceSku) }

    before do
      allow(BookingResourceSku).to receive(:find_by_id) { booking_resource_sku }
    end

    it 'finds the booking_resource_sku by the id' do
      described_class.call(call_params)

      expect(BookingResourceSku).to have_received(:find_by_id).with('booking_resource_sku_id')
    end

    it 'sets the success context' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end

    it 'sets the booking resource sku context' do
      context = described_class.call(call_params)

      expect(context.booking_resource_sku).to eq(booking_resource_sku)
    end

    context 'when the booking_resource_sku is missing' do
      before do
        allow(BookingResourceSku).to receive(:find_by_id) { nil }
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq(I18n.t('errors.not_found'))
      end

      it 'sets the error context' do
        context = described_class.call(call_params)

        expect(context).to be_failure
      end
    end
  end
end