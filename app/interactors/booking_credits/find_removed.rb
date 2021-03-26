# frozen_string_literal: true

module BookingCredits
  class FindRemoved
    include Interactor

    delegate :booking, to: :context

    def call
      context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?

      # INFO: We do not support removing a already referenced credits up until now. However we leave this here
      # as a reference for a future developer if our requirements change.
      context.removed_booking_credits = []
    end
  end
end
