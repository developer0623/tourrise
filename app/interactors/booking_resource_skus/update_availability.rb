# frozen_string_literal: true

module BookingResourceSkus
  class UpdateAvailability
    include Interactor

    def call
      return if context.booking_resource_sku.booking_resource_sku_availability.blank?
      return if context.booking_resource_sku.booking_resource_sku_availability.availability.blank?

      validate_availability

      CommitBookingResourceSku.call(context) if context.booking_resource_sku.booking.booked?
    end

    private

    def validate_availability
      booking_resource_sku_availability = context.booking_resource_sku.booking_resource_sku_availability
      return unless booking_resource_sku_availability.open?

      availability_service = AvailabilityService.new(booking_resource_sku_availability.availability)

      quantity = context.booking_resource_sku.required_quantity
      starts_on = context.booking_resource_sku.starts_on
      ends_on = context.booking_resource_sku.ends_on

      context.fail!(message: I18n.t("booking_resource_skus.errors.not_available")) unless availability_service.available?(quantity, starts_on, ends_on)
    end
  end
end
