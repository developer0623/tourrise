# frozen_string_literal: true

class BookingDocument < ApplicationRecord
  self.abstract_class = true

  has_one_attached :pdf

  serialize :booking_snapshot, JSON
  serialize :customer_snapshot, JSON
  serialize :product_sku_snapshot, JSON
  serialize :resource_skus_snapshot, JSON
  serialize :booking_resource_skus_snapshot, JSON
  serialize :booking_resource_sku_groups_snapshot, JSON
  serialize :booking_credits_snapshot, JSON

  belongs_to :booking, touch: true

  has_many :document_references, as: :document

  def booking_resource_skus
    BookingResourceSku.by_document(self)
  end

  def created_booking_resource_skus
    @created_booking_resource_skus ||= BookingResourceSku.created_by_document(self)
  end

  def updated_booking_resource_skus
    @updated_booking_resource_skus ||= BookingResourceSku.updated_by_document(self)
  end

  def canceled_booking_resource_skus
    @canceled_booking_resource_skus ||= BookingResourceSku.removed_by_document(self)
  end

  def published?
    scrambled_id.present?
  end

  def booking_resource_sku_ids
    return [] unless booking_resource_skus_snapshot.present?

    booking_resource_skus_snapshot.map do |booking_resource_sku_snapshot|
      booking_resource_sku_snapshot["id"].to_i
    end
  end

  def booking_resource_sku_group_ids
    return [] unless booking_resource_sku_groups_snapshot.present?

    booking_resource_sku_groups_snapshot.map do |booking_resource_sku_group_snapshot|
      booking_resource_sku_group_snapshot["id"].to_i
    end
  end

  def total_price
    unreduced_price - Money.new(credits_price_cents)
  end

  def unreduced_price
    Money.new(booking_resource_skus_price_cents + booking_resource_sku_groups_price_cents)
  end

  private

  def booking_resource_sku_groups_price_cents
    booking_resource_sku_groups = document_references.select do |reference|
      reference.item_type == "BookingResourceSkuGroup"
    end

    booking_resource_sku_groups.sum(&:price_cents)
  end

  def credits_price_cents
    booking_credits = document_references.select do |reference|
      reference.item_type == "BookingCredit"
    end

    booking_credits.sum(&:price_cents)
  end

  def booking_resource_skus_price_cents
    not_grouped_booking_resource_skus = document_references.select do |reference|
      reference.item_type == "BookingResourceSku" && !reference.item.internal
    end

    not_grouped_booking_resource_skus.sum(&:price_cents)
  end
end
