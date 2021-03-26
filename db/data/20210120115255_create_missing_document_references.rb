# frozen_string_literal: true

class CreateMissingDocumentReferences < ActiveRecord::Migration[6.0]

  class DocumentReference < ApplicationRecord
    belongs_to :document, polymorphic: true
    belongs_to :item, -> { with_deleted }, polymorphic: true

    validates :item_version_id, presence: true
  end

  REFERENCE_MAP = {
    BookingResourceSku => "booking_resource_skus_snapshot",
    BookingResourceSkuGroup => "booking_resource_sku_groups_snapshot",
    BookingCredit =>  "booking_credits_snapshot"
  }.freeze

  def up
    BookingOffer.find_each do |document|
      create_document_references(document)
    end

    BookingInvoice.find_each do |document|
      create_document_references(document)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def create_document_references(document)
    REFERENCE_MAP.each do |klazz, snapshot_method|
      snapshots = document.public_send(snapshot_method) || []
      snapshots.each do |snapshot|
        next if snapshot["id"].blank?

        item = klazz.unscoped.find_by_id(snapshot["id"])

        create_document_reference(document, item)
      end
    end
  end

  def create_document_reference(document, item)
    item.paper_trail.save_with_version if item.versions.empty?

    version = item.paper_trail.version_at(document.created_at)&.version&.previous || item.versions.last

    DocumentReference.find_or_create_by!(
      item: item,
      item_version_id: version.id,
      document: document
    )
  end
end
