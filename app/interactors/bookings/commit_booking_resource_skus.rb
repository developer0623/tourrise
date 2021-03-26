# frozen_string_literal: true

module Bookings
  class CommitBookingResourceSkus
    include Interactor

    def call
      context.booking.booking_resource_skus.each do |booking_resource_sku|
        context.booking_resource_sku = booking_resource_sku
        validator = BookingResourceSkuValidator.new(booking_resource_sku)

        context.fail!(message: validator.errors.full_messages) unless validator.valid?

        BookingResourceSkus::CommitBookingResourceSku.call!(context)
      end
    end
  end
end
