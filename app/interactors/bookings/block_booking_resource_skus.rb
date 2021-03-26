# frozen_string_literal: true

module Bookings
  class BlockBookingResourceSkus
    include Interactor

    def call
      context.booking.booking_resource_skus.each do |booking_resource_sku|
        context.booking_resource_sku = booking_resource_sku

        BookingResourceSkus::BlockBookingResourceSku.call!(context)
      end
    end
  end
end
