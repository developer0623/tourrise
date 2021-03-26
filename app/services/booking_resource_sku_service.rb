# frozen_string_literal: true

class BookingResourceSkuService
  attr_reader :booking_resource_sku

  def initialize(booking_resource_sku)
    @booking_resource_sku = booking_resource_sku
  end

  def blockable?
    return false unless booking_resource_sku.booking.in_progress?
    return false if booking_resource_sku.booking_resource_sku_availability.blank?

    bookable_availability?
  end

  def bookable?
    return true if booking_resource_sku.booking_resource_sku_availability.blank?

    availability = booking_resource_sku.booking_resource_sku_availability
    return true if availability.blocked? || availability.booked?

    bookable_availability?
  end

  private

  def bookable_availability?
    availability = booking_resource_sku.availability
    return true unless availability.present?

    availability_service = AvailabilityService.new(booking_resource_sku.availability)

    availability_service.available?(booking_resource_sku.required_quantity, booking_resource_sku.starts_on, booking_resource_sku.ends_on)
  end
end
