# frozen_string_literal: true

module Api
  module V1
    class SerializableBookingOffer < JSONAPI::Serializable::Resource
      type "booking_offers"

      attributes :id, :created_at, :updated_at
    end
  end
end
