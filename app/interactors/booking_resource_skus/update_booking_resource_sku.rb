# frozen_string_literal: true

module BookingResourceSkus
  class UpdateBookingResourceSku
    include Interactor::Organizer

    before do
      context.secondary_state = :offer_missing
    end

    organize Bookings::LoadBooking,
             LoadBookingResourceSku,
             UpdateBookingResourceSkuAttributes,
             UpdateAvailability,
             SaveBookingResourceSku,
             Bookings::ChangeSecondaryState
  end
end
