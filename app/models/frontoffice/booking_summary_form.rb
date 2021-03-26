# frozen_string_literal: true

module Frontoffice
  class BookingSummaryForm < BookingFormBase
    FORM_FIELDS = [].freeze

    delegate :booking_rentalbike_requests,
             :booking_rentalcar_requests,
             :booking_flight_requests, to: :booking
  end
end
