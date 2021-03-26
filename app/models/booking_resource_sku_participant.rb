# frozen_string_literal: true

class BookingResourceSkuParticipant < ApplicationRecord
  belongs_to :participant
  belongs_to :booking_resource_sku
end
