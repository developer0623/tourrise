# frozen_string_literal: true

module Bookings
  class SaveBooking
    include Interactor

    def call
      context.fail!(message: context.booking.errors.full_messages) unless context.booking.save
    end
  end
end
