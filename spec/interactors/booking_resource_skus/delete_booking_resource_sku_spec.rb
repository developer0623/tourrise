require 'rails_helper'

RSpec.describe BookingResourceSkus::DeleteBookingResourceSku, type: :interactor do
  describe '.call' do
    let(:booking) { instance_double(Booking, id: 1) }
    let(:booking_resource_sku) { instance_double(BookingResourceSku, id: 1) }
    let(:booking_resource_sku_id) { 1 }

    before do
      allow(BookingResourceSkus::LoadBookingResourceSku).to receive(:call)
      allow(Bookings::ChangeSecondaryState).to receive(:call) { true }
      allow(booking_resource_sku).to receive(:destroy) { true }
      allow(booking).to receive_message_chain(:booking_resource_sku_groups, :any?) { false }
    end

    it 'calls the LoadBookingResourceSku interactor' do
      context = described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

      expect(BookingResourceSkus::LoadBookingResourceSku).to have_received(:call).with(context)
    end

    it 'deletes the booking_resource_sku' do
      context = described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

      expect(booking_resource_sku).to have_received(:destroy)
    end

    it 'calls the ChangeSecondaryState interactor' do
      described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

      expect(Bookings::ChangeSecondaryState).to have_received(:call)
    end

    context 'when the booking_resource_sku is the last element of a booking_resource_sku_group' do
      let(:booking_resource_sku_groups) { [associated_booking_resource_sku_group] }
      let(:associated_booking_resource_sku_group) { instance_double('BookingResourceSkuGroup', id: 1, booking_resource_sku_ids: [1]) }
      let(:delete_group_context) { double(:delete_group_context, failure?: false) }

      before do
        allow(booking).to receive_message_chain(:booking_resource_sku_groups, :any?) { true }
        allow(booking).to receive(:booking_resource_sku_groups) { booking_resource_sku_groups }
        allow(BookingResourceSkuGroups::DeleteBookingResourceSkuGroup).to receive(:call) { delete_group_context }
      end

      it 'deletes the associated booking_resource_sku_group' do
        context = described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

        expect(BookingResourceSkuGroups::DeleteBookingResourceSkuGroup).to have_received(:call).with(booking_resource_sku_group_id: 1, booking: booking)
      end

      context 'when deleting the associated_booking_resource_sku_group fails' do
        let(:delete_group_context) { double(:delete_group_context, failure?: true, message: 'deleting_group_error') }

        it 'shows the error message' do
          context = described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

          expect(context.message).to eq('deleting_group_error')
        end
      end
    end

    context 'when the booking_resource_sku could not be deleted' do
      before do
        allow(booking_resource_sku).to receive(:destroy) { false }
        allow(booking_resource_sku).to receive(:errors) { double('errors', full_messages: 'an_error') }
      end

      it 'sets the error message' do
        context = described_class.call(booking: booking, booking_resource_sku: booking_resource_sku)

        expect(context.message).to eq('an_error')
      end
    end
  end
end
