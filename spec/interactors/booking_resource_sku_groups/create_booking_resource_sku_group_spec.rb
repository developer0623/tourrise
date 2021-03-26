# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingResourceSkuGroups::CreateBookingResourceSkuGroup, type: :interactor do
  let(:booking_resource_sku_group) { instance_double('BookingResourceSkuGroup') }
  let(:grouped_booking_resource_sku_ids) { [1,2] }
  let(:booking) { instance_double('Booking', id: 'booking_id', booking_resource_skus: booking_resource_skus) }
  let(:booking_resource_skus) { object_double(BookingResourceSku.all) }
  let(:booking_resource_sku) { instance_double('BookingResourceSku') }

  describe '.call' do
    before do
      allow(BookingResourceSkuGroup).to receive(:new) { booking_resource_sku_group }
      allow(booking_resource_sku_group).to receive(:save) { true }
      allow(booking_resource_sku_group).to receive(:booking_resource_sku_ids) { grouped_booking_resource_sku_ids }
      allow(booking).to receive(:booked?) { false }

      allow(booking_resource_skus).to receive(:where) { [booking_resource_sku] }
      allow(booking_resource_sku).to receive(:update) { true }

      allow(Bookings::ChangeSecondaryState).to receive(:call) { true }
    end

    let(:create_params) do
      {
        name: 'Servicepaket',
        booking_resource_sku_ids: grouped_booking_resource_sku_ids,
        price: "10.11",
        booking: booking,
        allow_partial_payment: false
      }.stringify_keys
    end

    it 'initializes new booking resource sku group' do
      described_class.call(params: create_params, booking: booking)

      expected_create_params = {
        name: "Servicepaket",
        booking_resource_sku_ids: grouped_booking_resource_sku_ids,
        price_cents: "1011",
        price_currency: MoneyRails.default_currency,
        booking_id: 'booking_id',
        allow_partial_payment: false
      }.stringify_keys
      expect(BookingResourceSkuGroup).to have_received(:new).with(expected_create_params)
    end

    it 'is successful' do
      context = described_class.call(params: create_params, booking: booking)

      expect(context.success?).to be(true)
    end

    it 'hides the booking resource skus' do
      context = described_class.call(params: create_params, booking: booking)

      expect(context.booking.booking_resource_skus).to have_received(:where).with(id: grouped_booking_resource_sku_ids)
      expect(booking_resource_sku).to have_received(:update).with(internal: true)
    end

    context 'when save fails' do
      before do
        allow(BookingResourceSkuGroup).to receive(:new) { booking_resource_sku_group }
        allow(booking_resource_sku_group).to receive(:save) { false }
        allow(booking_resource_sku_group).to receive(:errors) { double('errors', full_messages: 'an_error') }
      end

      it 'is a failure' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context).to be_a_failure
      end

      it 'sets the error message' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context.message).to eq('an_error')
      end
    end

    context 'when hiding fails' do
      before do
        allow(BookingResourceSkuGroup).to receive(:new) { booking_resource_sku_group }
        allow(booking_resource_sku).to receive(:update) { false }
      end

      it 'is a failure' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context).to be_a_failure
      end

      it 'sets the error message' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context.message).to eq(I18n.t("booking_resource_sku_groups.create.cannot_hide_booking_resource_skus"))
      end
    end

    context 'when the booking is in booked state' do
      before do
        allow(booking).to receive(:booked?) { true }
      end

      it 'is a failure' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context).to be_a_failure
      end

      it 'sets the error message' do
        context = described_class.call(params: create_params, booking: booking)

        expect(context.message).to eq(I18n.t("booking_resource_sku_groups.create.fail_booking_booked"))
      end
    end
  end
end