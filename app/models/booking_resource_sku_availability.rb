# frozen_string_literal: true

class BookingResourceSkuAvailability < ApplicationRecord
  belongs_to :booking_resource_sku
  belongs_to :availability

  belongs_to :blocked_by, class_name: "User", optional: true
  belongs_to :booked_by, class_name: "User", optional: true

  validates :blocked_by, presence: true, if: :blocked?
  validates :booked_by, presence: true, if: :booked?
  validates :booked_at, presence: true, if: -> { booking_resource_sku.booking.booked? }

  def open?
    !blocked? && !booked?
  end

  def blocked?
    blocked_at.present?
  end

  def booked?
    booked_at.present?
  end
end
