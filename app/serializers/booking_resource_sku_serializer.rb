# frozen_string_literal: true

class BookingResourceSkuSerializer < JSONAPI::Serializable::Resource
  KEYS = %w[
    id
    quantity
    internal
    booking_id
    resource_sku_id
    resource_snapshot
    resource_sku_snapshot
    booking_attribute_values
    participants
    flights
    price_cents
    allow_partial_payment
    booking_resource_sku_ids
    cost_center
    financial_account
    starts_on
    ends_on
  ].freeze

  type "booking_resource_sku"

  attributes :id,
             :resource_sku_snapshot,
             :resource_snapshot,
             :quantity,
             :price_cents,
             :price_currency,
             :resource_sku_id
end
