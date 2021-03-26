# frozen_string_literal: true

module BookingCredits
  module AddDocumentReferences
    class ForCreated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.created_booking_credits
      end

      def price_info
        context.created_booking_credits_price_info
      end

      def action
        "added"
      end
    end
  end
end
