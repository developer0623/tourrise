# frozen_string_literal: true

class BookingResourceSkuFlight < ApplicationRecord
  belongs_to :flight
  belongs_to :booking_resource_sku
end
