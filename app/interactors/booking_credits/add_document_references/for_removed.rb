# frozen_string_literal: true

module BookingCredits
  module AddDocumentReferences
    class ForRemoved < Documents::AddDocumentReferences::Base
      private

      def collection
        context.removed_booking_credits
      end

      def price_info
        context.removed_booking_credits_price_info
      end

      def action
        "canceled"
      end
    end
  end
end
