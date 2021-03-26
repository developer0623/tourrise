# frozen_string_literal: true

module BookingCredits
  module RecalculatePrice
    class ForRemoved
      include Interactor

      delegate :removed_booking_credits, :document_type, to: :context

      # INFO: We do not support removing a already referenced credits up until now. However we leave this here
      # as a reference for a future developer if our requirements change.
      def call
        context.removed_booking_credits_price_info = {}
      end
    end
  end
end
