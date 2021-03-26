# frozen_string_literal: true

module Api
  module V1
    class SerializablePayment < JSONAPI::Serializable::Resource
      type "payments"

      attributes :id, :due_on, :price
    end
  end
end
