# frozen_string_literal: true

module BookingResourceSkus
  class UnblockBookingResourceSku
    include Interactor

    before :load_booking_resource_sku

    def call
      return if context.booking_resource_sku.availability.blank?

      context.booking_resource_sku_availability = context.booking_resource_sku.booking_resource_sku_availability

      BookingResourceSkuAvailabilities::UnblockBookingResourceSkuAvailability.call(context)
    end

    private

    def load_booking_resource_sku
      context.booking_resource_sku || LoadBookingResourceSku.call(context)
    end
  end
end
