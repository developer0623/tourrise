# frozen_string_literal: true

class BookingParticipant < ApplicationRecord
  self.table_name = "booking_customers"

  delegate :customer, :product, :product_sku, to: :booking
  delegate :translations, to: :product, prefix: true
  delegate :translations, to: :product_sku, prefix: true

  belongs_to :booking
  belongs_to :participant, class_name: "Participant", foreign_key: "customer_id"
end
