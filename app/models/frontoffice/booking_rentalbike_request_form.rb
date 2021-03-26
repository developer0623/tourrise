# frozen_string_literal: true

module Frontoffice
  class BookingRentalbikeRequestForm < BookingFormBase
    FORM_FIELDS = %w[
      rentalbikes_count
      booking_rentalbike_requests_attributes
    ].freeze

    attr_accessor(*FORM_FIELDS)

    delegate :booking_rentalbike_requests, to: :booking

    before_save :reset_booking_rentalbike_requests

    def booking_rentalbike_requests_attributes
      return [] if @booking_rentalbike_requests_attributes.blank?

      @booking_rentalbike_requests_attributes
    end

    private

    def reset_booking_rentalbike_requests
      return if booking_rentalbike_requests.blank?

      rentalbikes_difference = booking_rentalbike_requests.count - rentalbikes_count.to_i

      booking.booking_rentalbike_requests.last(rentalbikes_difference).each(&:destroy) if rentalbikes_difference.positive?
    end
  end
end
