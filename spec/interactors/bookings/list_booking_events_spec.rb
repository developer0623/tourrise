# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bookings::ListBookingEvents do
  describe '.call' do
    subject { described_class.call(booking: booking) }

    let(:booking) { create(:booking) }

    context 'returns all booking events' do
      let(:events) { double(:events) }
      let(:booking) { double(:booking) }
      let(:booking_resource_skus) { double(:booking_resource_skus, with_deleted: []) }
      let(:booking_resource_skus_groups) { double(:booking_resource_skus, with_deleted: []) }

      before do
        allow(PaperTrail::Version).to receive(:where) { events }
        allow(booking).to receive(:customer) { [] }
        allow(booking).to receive(:participants) { [] }
        allow(booking).to receive(:booking_offers) { [] }
        allow(booking).to receive(:booking_invoices) { [] }
        allow(booking).to receive(:booking_resource_skus) { booking_resource_skus }
        allow(booking).to receive(:booking_resource_sku_groups) { booking_resource_skus_groups }
        allow(events).to receive(:page) { double(:page, per: []) }
        allow(PaperTrail::Version).to receive(:all).and_return(events)
      end

      it { expect(subject.events).to eq([]) }
    end

    context 'shows deleted booking_resource_skus' do
      let(:booking_resource_sku) { create(:booking_resource_sku, booking: booking) }
      let(:create_attrs) { { item_type: "BookingResourceSku", event: "create" } }
      let(:destroy_attrs) { { item_type: "BookingResourceSku", event: "destroy" } }

      before do
        booking_resource_sku.destroy

        allow(booking).to receive(:participants) { [] }
        allow(booking).to receive(:booking_offers) { [] }
        allow(booking).to receive(:booking_invoices) { [] }
      end

      it { expect(subject.events.where(destroy_attrs).count).not_to be_zero }
      it { expect(subject.events.where(create_attrs).count).not_to be_zero }
    end

    context 'shows deleted booking_resource_sku_groups' do
      let(:booking_resource_sku_group) { create(:booking_resource_sku_group, booking: booking) }
      let(:create_attrs) { { item_type: "BookingResourceSkuGroup", event: "create" } }
      let(:destroy_attrs) { { item_type: "BookingResourceSkuGroup", event: "destroy" } }

      before do
        booking_resource_sku_group.destroy

        allow(booking).to receive(:participants) { [] }
        allow(booking).to receive(:booking_offers) { [] }
        allow(booking).to receive(:booking_invoices) { [] }
      end

      it { expect(subject.events.where(destroy_attrs).count).not_to be_zero }
      it { expect(subject.events.where(create_attrs).count).not_to be_zero }
    end
  end
end
