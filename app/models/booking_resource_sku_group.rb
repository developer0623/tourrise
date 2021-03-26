# frozen_string_literal: true

class BookingResourceSkuGroup < ApplicationRecord
  include Referenceable
  include Cancellable

  acts_as_paranoid

  has_paper_trail ignore: %i[created_at updated_at]

  monetize :price_cents

  belongs_to :booking, touch: true
  belongs_to :financial_account, optional: true
  belongs_to :cost_center, optional: true
  has_and_belongs_to_many :booking_resource_skus

  def cost_center
    super || booking.product_sku.cost_center
  end

  def financial_account
    super || booking.product_sku.financial_account
  end

  def vat
    booking_resource_skus.first&.vat || 0
  end

  def serialize_for_snapshot
    methods = %i[price booking_resource_sku_ids vat cost_center financial_account]

    serializable_hash(methods: methods).slice(*BookingResourceSkuGroupSerializer::KEYS)
  end
end
