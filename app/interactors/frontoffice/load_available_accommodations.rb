# frozen_string_literal: true

module Frontoffice
  class LoadAvailableAccommodations
    include Interactor

    def call
      context.accommodations = product_sku.resources.where(resource_type_id: accommodation_resource_type).map do |resource|
        [
          resource,
          resource.resource_skus.available.map do |room|
            next unless room.present?

            next unless available_for_booking?(room)
            next unless matches_occupation_configuration?(room)

            room
          end.compact
        ].compact
      end
    end

    private

    def available_for_booking?(sku)
      resource_sku_availability_service = ResourceSkuAvailabilityService.new(sku)

      resource_sku_availability_service.available_for_booking?(context.booking)
    end

    def matches_occupation_configuration?(sku)
      occupation_service = ResourceSkuOccupationService.new(sku)

      occupation_service.matches_occupation_configuration?(adults: adults, kids: kids, babies: babies)
    end

    def adults
      context.booking_room_assignment&.adults.to_i
    end

    def kids
      context.booking_room_assignment&.kids.to_i
    end

    def babies
      context.booking_room_assignment&.babies.to_i
    end

    def product_sku
      context.booking.product_sku
    end

    def accommodation_resource_type
      accommodation_resource_type ||= ResourceType.find_by(handle: :accommodation)
    end
  end
end
