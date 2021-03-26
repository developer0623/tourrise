# frozen_string_literal: true

class BookingResourceSkuCustomer < ApplicationRecord
  belongs_to :booking_resource_sku
  belongs_to :customer
end
