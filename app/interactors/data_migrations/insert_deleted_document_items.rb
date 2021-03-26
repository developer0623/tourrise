# frozen_string_literal: true

module DataMigrations
  class InsertDeletedDocumentItems
    include Interactor

    REFERENCE_MAP = {
      BookingResourceSku => "booking_resource_skus_snapshot",
      BookingResourceSkuGroup => "booking_resource_sku_groups_snapshot"
    }.freeze

    def call
      BookingOffer.find_each do |document|
        insert_deleted_items(document)
      end

      BookingInvoice.find_each do |document|
        insert_deleted_items(document)
      end
    end

    private

    def insert_deleted_items(document)
      REFERENCE_MAP.each do |klazz, snapshot_method|
        snapshots = document.public_send(snapshot_method) || []
        snapshots.each do |snapshot|
          next if snapshot["id"].blank?

          item = klazz.unscoped.find_by_id(snapshot["id"])
          next if item.present?

          attributes_to_insert = snapshot.slice(*klazz.new.attributes.keys)
          attributes_to_insert = attributes_to_insert.merge("deleted_at" => document.created_at + 1.minute)

          context.fail! unless klazz.insert!(attributes_to_insert)
        end
      end
    end
  end
end
