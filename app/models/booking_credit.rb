# frozen_string_literal: true

class BookingCredit < ApplicationRecord
  include Referenceable

  acts_as_paranoid

  has_paper_trail ignore: %i[created_at updated_at]

  monetize :price_cents

  belongs_to :booking, touch: true
  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true

  validates :price_cents, numericality: { greater_than: 0 }
  validate :invoiced_only_once

  def cost_center
    super || booking.product_sku.cost_center
  end

  def financial_account
    super || booking.product_sku.financial_account
  end

  def serialize_as_booking_resource_sku_snapshot
    snapshot = serialize_for_snapshot
    snapshot["quantity"] = 1
    snapshot["resource_sku_snapshot"] = { "handle" => "-", "name" => snapshot["name"] }

    snapshot
  end

  def serialize_for_snapshot
    methods = %i[cost_center financial_account]

    serializable_hash(methods: methods).slice(*BookingCreditSerializer::KEYS)
  end

  def offer
    offers.first
  end

  private

  def invoiced_only_once
    errors.add(:base, :invoiced_once) if invoices.any?
  end
end
