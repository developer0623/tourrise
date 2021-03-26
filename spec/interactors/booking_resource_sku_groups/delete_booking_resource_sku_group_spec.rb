# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingResourceSkuGroups::DeleteBookingResourceSkuGroup, type: :interactor do
  describe '.call' do
    let(:booking_resource_sku_group_id) { 1 }
    let(:booking_resource_sku_group) { instance_double('BookingResourceSkuGroup', id: booking_resource_sku_group_id) }
    let(:grouped_booking_resource_sku_ids) { [1,2] }
    let(:booking) { instance_double('Booking', booking_resource_skus: booking_resource_skus) }
    let(:booking_resource_skus) { object_double(BookingResourceSku.all) }
    let(:booking_resource_sku) { instance_double(BookingResourceSku) }

    before do
      allow(BookingResourceSkuGroup).to receive(:find_by) { booking_resource_sku_group }
      allow(booking_resource_sku_group).to receive(:booking_resource_sku_ids) { grouped_booking_resource_sku_ids }
      allow(booking_resource_sku_group).to receive(:destroy) { true }
      allow(booking_resource_skus).to receive(:where) { [booking_resource_sku] }
      allow(booking_resource_sku).to receive(:update_attribute) { true }

      allow(Bookings::ChangeSecondaryState).to receive(:call) { true }
    end

    it 'finds the group' do
      context = described_class.call(
        booking_resource_sku_group_id: booking_resource_sku_group_id,
        booking: booking
      )

      expect(BookingResourceSkuGroup).to have_received(:find_by).with(id: booking_resource_sku_group_id)
    end

    it 'finds the grouped booking resource skus' do
      context = described_class.call(
        booking_resource_sku_group_id: booking_resource_sku_group_id,
        booking: booking
      )

      expect(context.booking.booking_resource_skus).to have_received(:where).with(id: grouped_booking_resource_sku_ids)
    end

    it 'shows the booking resource skus' do
      context = described_class.call(
        booking_resource_sku_group_id: booking_resource_sku_group_id,
        booking: booking
      )

      expect(booking_resource_sku).to have_received(:update_attribute).with(:internal, false)
    end

    context 'when the group cannot be found' do
      before do
        allow(BookingResourceSkuGroup).to receive(:find_by) { nil }
      end

      it 'returns true' do
        context = described_class.call(
          booking_resource_sku_group_id: booking_resource_sku_group_id,
          booking: booking
        )

        expect(context.success?).to eq(true)
      end
    end

    context 'when destroy fails' do
      before do
        allow(booking_resource_sku_group).to receive(:destroy) { false }
        allow(booking_resource_sku_group).to receive(:errors) { double('errors', full_messages: 'an_error') }
      end

      it 'is a failure' do
        context = described_class.call(
          booking_resource_sku_group_id: booking_resource_sku_group_id,
          booking: booking
        )

        expect(context).to be_a_failure
      end

      it 'sets the error message' do
        context = described_class.call(
          booking_resource_sku_group_id: booking_resource_sku_group_id,
          booking: booking
        )

        expect(context.message).to eq('an_error')
      end

      context 'when show skus fails' do
        before do
          allow(booking_resource_sku).to receive(:update_attribute) { false }
        end

        it 'is a failure' do
          context = described_class.call(
            booking_resource_sku_group_id: booking_resource_sku_group_id,
            booking: booking
          )

          expect(context).to be_a_failure
        end

        it 'sets the error message' do
          context = described_class.call(
            booking_resource_sku_group_id: booking_resource_sku_group_id,
            booking: booking
          )

          expect(context.message).to eq(I18n.t("booking_resource_sku_groups.destroy.cannot_show_booking_resource_skus"))
        end
      end
    end
  end
end