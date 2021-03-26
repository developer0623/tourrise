# frozen_string_literal: true

module Frontoffice
  class LoadBooking
    include Interactor

    def call
      context.booking = Booking.find_by(scrambled_id: context.scrambled_id)

      context.fail!(code: :not_found, message: :not_found) unless context.booking.present?
      context.fail!(code: :submitted, message: :already_submitted) unless context.booking.draft?
    end
  end
end
