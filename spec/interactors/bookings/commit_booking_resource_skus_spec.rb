require 'rails_helper'

RSpec.describe Bookings::CommitBookingResourceSkus, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double(Booking,
                                    booking_resource_skus: booking_resource_skus,
                                    adults: 1,
                                    kids: 1,
                                    babies: 1) }
    let(:booking_resource_skus) { %w[booking_resource_sku_1]}
    let(:validator) { instance_double(BookingResourceSkuValidator) }

    let(:call_params) do
      { booking: booking }
    end

    before do
      allow(BookingResourceSkus::CommitBookingResourceSku).to receive(:call!) { true }
      allow(BookingResourceSkuValidator).to receive(:new) { validator }
      allow(validator).to receive(:valid?) { true }
    end

    it 'succeeds' do
      context = described_class.call(call_params)

      expect(context).to be_success
    end

    it 'assigns the booking resource sku to the context' do
      context = described_class.call(call_params)

      expect(context.booking_resource_sku).to eq('booking_resource_sku_1')
    end

    it 'calls booking resource sku validator' do
      described_class.call(call_params)

      expect(BookingResourceSkuValidator).to have_received(:new).with("booking_resource_sku_1")
    end

    it 'calls the commit booking resource sku interactor for each booking resource sku' do
      context = described_class.call(call_params)

      expect(BookingResourceSkus::CommitBookingResourceSku).to have_received(:call!).with(context)
    end

    context 'when validation fails' do
      before do
        allow(validator).to receive(:valid?) { false }
        allow(validator).to receive(:errors) { double('errors', full_messages: 'an_error') }
      end

      it 'is a failure' do
        context = described_class.call(call_params)

        expect(context).to be_a_failure
      end

      it 'sets the error message' do
        context = described_class.call(call_params)

        expect(context.message).to eq('an_error')
      end
    end
  end
end
