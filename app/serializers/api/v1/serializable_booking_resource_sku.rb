# frozen_string_literal: true

module Api
  module V1
    class SerializableBookingResourceSku < JSONAPI::Serializable::Resource
      type "booking_resource_skus"

      belongs_to :booking
      has_many :participants
      has_many :booking_attribute_values

      attributes :id,
                 :resource_sku_snapshot,
                 :resource_snapshot,
                 :quantity,
                 :price,
                 :cost_center,
                 :financial_account,
                 :starts_on,
                 :ends_on,
                 :remarks

      attribute :status do
        @object.booking.aasm_state
      end

      attribute :starts_on do
        @object.starts_on
      end

      attribute :ends_on do
        @object.ends_on
      end
    end
  end
end
