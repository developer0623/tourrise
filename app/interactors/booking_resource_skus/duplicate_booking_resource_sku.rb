# frozen_string_literal: true

module BookingResourceSkus
  class DuplicateBookingResourceSku
    include Interactor::Organizer

    before :initialize_new_booking_resource_sku

    organize Bookings::LoadBooking, LoadBookingResourceSku, CopyAttributes

    private

    def initialize_new_booking_resource_sku
      context.new_booking_resource_sku = BookingResourceSku.new
    end
  end
end
