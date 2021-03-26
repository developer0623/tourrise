# frozen_string_literal: true

class BookingCreditSerializer < JSONAPI::Serializable::Resource
  KEYS = %w[
    id
    name
    handle
    booking_id
    price_cents
    price_currency
    cost_center
    financial_account
    created_at
    updated_at
  ].freeze

  type "booking_credit"

  attributes :id,
             :booking_id,
             :name,
             :price_cents,
             :price_currency
end
