# frozen_string_literal: true

module BookingCredits
  class CreateBookingCredit
    include Interactor

    delegate :booking_credit, :params, :booking_id, to: :context

    before do
      initialize_booking_credit
    end

    def call
      booking_credit.assign_attributes(params)

      context.fail!(message: booking_credit.errors.full_messages) unless booking_credit.save
    end

    private

    def initialize_booking_credit
      context.booking_credit = Booking.find(booking_id).booking_credits.new
    end
  end
end
