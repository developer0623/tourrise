# frozen_string_literal: true

module BookingResourceSkus
  class AssignAvailability
    include Interactor

    def call
      return unless resource_sku_availability_service.needs_availability?

      find_bookable_availability_by_score

      context.booking_resource_sku.availability = context.bookable_availability if context.bookable_availability.present?
      CommitBookingResourceSku.call(context) if context.booking.booked?
    end

    private

    def resource_sku_availability_service
      @resource_sku_availability_service ||= ResourceSkuAvailabilityService.new(context.resource_sku)
    end

    def find_bookable_availability_by_score
      context.bookable_availability = resource_sku_availability_service.find_bookable_availability_by_score(
        context.booking_resource_sku.required_quantity,
        context.booking_resource_sku.starts_on,
        context.booking_resource_sku.ends_on
      )

      return if context.bookable_availability.present?

      context.fail!(message: I18n.t("booking_resource_skus.errors.not_available")) if context.fail_on_unavailability.present?
    end
  end
end
