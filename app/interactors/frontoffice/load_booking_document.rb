# frozen_string_literal: true

module Frontoffice
  class LoadBookingDocument
    include Interactor

    private

    def load_booking
      context.booking = Booking.find_by(scrambled_id: context.booking_scrambled_id)

      context.fail!(message: :not_found) unless context.booking.present?
    end
  end
end
