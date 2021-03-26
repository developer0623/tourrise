# frozen_string_literal: true

module BookingResourceSkus
  class CreateBookingResourceSku
    include Interactor::Organizer

    before do
      context.booking_resource_sku = BookingResourceSku.new
      context.secondary_state = :offer_missing
    end

    organize Bookings::LoadBooking,
             ResourceSkus::LoadResourceSku,
             AssignBookingResourceSkuAttributes,
             AssignAvailability,
             SaveBookingResourceSku,
             Bookings::ChangeSecondaryState
  end
end
