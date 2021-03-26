# frozen_string_literal: true

module Frontoffice
  class BookingRentalcarRequestForm < BookingFormBase
    FORM_FIELDS = %w[
      booking_rentalcar_requests_attributes
      rentalcars_count
    ].freeze

    attr_accessor(*FORM_FIELDS)

    delegate :booking_rentalcar_requests, to: :booking

    before_save :reset_booking_rentalcar_requests

    def booking_rentalcar_requests_attributes
      return [] if @booking_rentalcar_requests_attributes.blank?

      @booking_rentalcar_requests_attributes
    end

    private

    def reset_booking_rentalcar_requests
      return if booking_rentalcar_requests.blank?

      rentalcars_difference = booking_rentalcar_requests.count - rentalcars_count.to_i

      booking.booking_rentalcar_requests.last(rentalcars_difference).each(&:mark_for_destruction) if rentalcars_difference.positive?
    end
  end
end
