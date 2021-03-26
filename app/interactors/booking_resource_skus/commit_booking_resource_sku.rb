# frozen_string_literal: true

module BookingResourceSkus
  class CommitBookingResourceSku
    include Interactor

    def call
      context.fail!(message: resource_sku_missing_message) unless context.booking_resource_sku.resource_sku.present?
      context.fail!(message: not_available_message) unless bookable?

      return if context.booking_resource_sku.booking_resource_sku_availability.blank?

      context.booking_resource_sku_availability = context.booking_resource_sku.booking_resource_sku_availability

      BookingResourceSkuAvailabilities::CommitBookingResourceSkuAvailability.call(context)
    end

    private

    def bookable?
      booking_resource_sku_service = BookingResourceSkuService.new(context.booking_resource_sku)

      booking_resource_sku_service.bookable?
    end

    def not_available_message
      I18n.t(
        "bookings.check_booking_resource_skus_availability.not_available",
        name: context.booking_resource_sku.resource_sku_snapshot["name"]
      )
    end

    def resource_sku_missing_message
      I18n.t(
        "bookings.check_booking_resource_skus_availability.resource_sku_missing",
        name: context.booking_resource_sku.resource_sku_snapshot["name"]
      )
    end
  end
end
