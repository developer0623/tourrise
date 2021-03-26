# frozen_string_literal: true

class BookingResourceSkuGroupSerializer < JSONAPI::Serializable::Resource
  KEYS = %w[
    id
    name
    booking_id
    vat
    price
    price_cents
    allow_partial_payment
    booking_resource_sku_ids
    cost_center
    financial_account
    created_at
    updated_at
  ].freeze

  type "booking_resource_sku_group"

  attributes :id,
             :booking_id,
             :name,
             :price_cents,
             :price_currency,
             :allow_partial_payment
end
