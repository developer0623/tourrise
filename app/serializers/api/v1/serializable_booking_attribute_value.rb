# frozen_string_literal: true

module Api
  module V1
    class SerializableBookingAttributeValue < JSONAPI::Serializable::Resource
      type "booking_attribute_values"

      attributes :id,
                 :name,
                 :handle,
                 :attribute_type,
                 :value
    end
  end
end
