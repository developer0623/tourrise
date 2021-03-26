# frozen_string_literal: true

class ResourceSkuAvailabilityService
  attr_reader :resource_sku

  def initialize(resource_sku)
    @resource_sku = resource_sku
  end

  def needs_availability?
    availabilities.any?
  end

  def available_for_booking?(booking)
    return true unless needs_availability?

    # TODO: @schnika maybe there is a way to tell how much quantity is requested at this point in time
    #       instead of simply assuming the requested quantity is 1
    bookable_availabilities(1, booking.starts_on, booking.ends_on).any?
  end

  def find_bookable_availability_by_score(quantity, starts_on, ends_on)
    return unless needs_availability?

    bookable_availabilities(quantity, starts_on, ends_on).min_by do |availability|
      availability_service = AvailabilityService.new(availability)

      availability_service.score(quantity, starts_on, ends_on)
    end
  end

  private

  def availabilities
    @availabilities ||= resource_sku.inventories.map(&:availabilities).flatten.compact
  end

  def bookable_availabilities(quantity, starts_on, ends_on)
    availabilities.select do |availability|
      availability_service = AvailabilityService.new(availability)

      availability_service.available?(quantity, starts_on, ends_on)
    end
  end
end
