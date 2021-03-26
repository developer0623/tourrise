# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataMigrations::InsertDeletedDocumentItems, type: :interactor do
  describe '.call' do
    context 'when a booking_resource_sku has been hard deleted' do
      let!(:booking_resource_sku) { create(:booking_resource_sku) }
      let!(:booking_offer) { create(:booking_offer, booking_resource_skus_snapshot: [booking_resource_sku.serialize_for_snapshot]) }

      before do
        booking_resource_sku.really_destroy!
      end

      it 'check that it is really deleted' do
        expect(BookingResourceSku.with_deleted.find_by(id: booking_resource_sku.id)).to be_blank
      end

      it 'inserts the deleted booking_resource_sku' do
        described_class.call

        expect(BookingResourceSku.with_deleted.find_by(id: booking_resource_sku.id)).to be_present
      end

      it 'is inserted with as deleted' do
        described_class.call

        expect(BookingResourceSku.with_deleted.find_by(id: booking_resource_sku.id)).to be_deleted
      end
    end

    context 'when a booking_resource_sku_group has been hard deleted' do
      let!(:booking_resource_sku) { create(:booking_resource_sku) }
      let!(:booking_resource_sku_group) { create(:booking_resource_sku_group, booking_resource_skus: [booking_resource_sku]) }
      let!(:booking_offer) do
        create(
          :booking_offer,
          booking_resource_skus_snapshot: [booking_resource_sku.serialize_for_snapshot],
          booking_resource_sku_groups_snapshot: [booking_resource_sku_group.serialize_for_snapshot]
        )
      end

      before do
        booking_resource_sku_group.really_destroy!
      end

      it 'check that it is really deleted' do
        expect(BookingResourceSkuGroup.with_deleted.find_by(id: booking_resource_sku_group.id)).to be_blank
      end

      it 'inserts the deleted booking_resource_sku_group' do
        described_class.call

        expect(BookingResourceSkuGroup.with_deleted.find_by(id: booking_resource_sku_group.id)).to be_present
      end

      it 'is inserted with as deleted' do
        described_class.call

        expect(BookingResourceSkuGroup.with_deleted.find_by(id: booking_resource_sku_group.id)).to be_deleted
      end
    end
  end
end
