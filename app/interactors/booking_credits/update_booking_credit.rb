# frozen_string_literal: true

module BookingCredits
  class UpdateBookingCredit
    include Interactor

    delegate :booking_credit, :booking_credit_id, :params, to: :context

    def call
      context.booking_credit = BookingCredit.find(booking_credit_id)

      context.fail!(message: booking_credit.errors.full_messages) unless booking_credit.update(params)
    end
  end
end
