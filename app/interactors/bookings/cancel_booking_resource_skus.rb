# frozen_string_literal: true

module Bookings
  class CancelBookingResourceSkus
    include Interactor

    def call
      context.booking.booking_resource_skus.each do |booking_resource_sku|
        context.booking_resource_sku = booking_resource_sku

        BookingResourceSkus::Cancel.call!(context)
      end
    end
  end
end
