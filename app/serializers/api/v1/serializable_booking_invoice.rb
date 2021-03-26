# frozen_string_literal: true

module Api
  module V1
    class SerializableBookingInvoice < JSONAPI::Serializable::Resource
      type "booking_invoices"

      belongs_to :booking
      has_many :payments

      attributes :id,
                 :total_price,
                 :created_at,
                 :updated_at
    end
  end
end
