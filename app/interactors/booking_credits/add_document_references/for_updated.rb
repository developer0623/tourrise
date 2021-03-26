# frozen_string_literal: true

module BookingCredits
  module AddDocumentReferences
    class ForUpdated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.updated_booking_credits
      end

      def price_info
        context.updated_booking_credits_price_info
      end

      def action
        "modified"
      end
    end
  end
end
