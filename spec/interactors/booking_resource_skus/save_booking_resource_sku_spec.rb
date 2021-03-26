require 'rails_helper'

RSpec.describe BookingResourceSkus::SaveBookingResourceSku, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku) { instance_double(BookingResourceSku) }

    let(:call_params) do
      {
        booking_resource_sku: booking_resource_sku
      }
    end

    before do
      allow(booking_resource_sku).to receive(:save) { true }
    end

    it 'sets the success context' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end

    context 'when the booking_resource_sku cannot be saved' do
      before do
        allow(booking_resource_sku).to receive(:save) { false }
        allow(booking_resource_sku).to receive(:errors) { double(:errors, full_messages: 'error_messages') }
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq('error_messages')
      end

      it 'sets the error context' do
        context = described_class.call(call_params)

        expect(context).to be_failure
      end
    end
  end
end