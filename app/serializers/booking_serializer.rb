# frozen_string_literal: true

class BookingSerializer < JSONAPI::Serializable::Resource
  type "booking"

  belongs_to :customer
  has_many :participants
  has_many :booking_resource_skus

  attributes :id,
             :product_sku_id,
             :adults,
             :kids,
             :babies,
             :starts_on,
             :ends_on
end
