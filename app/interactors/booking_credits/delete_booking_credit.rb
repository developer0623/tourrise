# frozen_string_literal: true

module BookingCredits
  class DeleteBookingCredit
    include Interactor

    delegate :booking_credit, :booking_credit_id, to: :context

    def call
      context.booking_credit ||= BookingCredit.find(booking_credit_id)

      context.fail!(message: I18n.t("booking_credits.destroy.already_invoiced_error")) if booking_credit.invoiced?

      context.fail!(message: booking_credit.errors.full_messages) unless booking_credit.destroy
    end
  end
end
