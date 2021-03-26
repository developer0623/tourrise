# frozen_string_literal: true

module BookingResourceSkus
  module AddDocumentReferences
    class ForCanceled < Documents::AddDocumentReferences::Base
      private

      def collection
        context.canceled_booking_resource_skus
      end

      def price_info
        context.canceled_booking_resource_skus_price_info
      end

      def action
        "canceled"
      end
    end
  end
end
