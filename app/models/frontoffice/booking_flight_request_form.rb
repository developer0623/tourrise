# frozen_string_literal: true

module Frontoffice
  class BookingFlightRequestForm < BookingFormBase
    FORM_FIELDS = %w[
      flights_count
      booking_flight_requests_attributes
    ].freeze

    attr_accessor(*FORM_FIELDS)

    delegate :booking_flight_requests, to: :booking

    before_save :reset_booking_flight_requests

    def booking_flight_requests_attributes
      return [] if @booking_flight_requests_attributes.blank?

      @booking_flight_requests_attributes
    end

    private

    def reset_booking_flight_requests
      booking_flight_requests = booking.booking_flight_requests
      return if booking_flight_requests.blank?

      flights_difference = booking_flight_requests.count - booking.people_count

      booking.booking_flight_requests.last(flights_difference).each(&:destroy) if flights_difference.positive?
    end
  end
end
