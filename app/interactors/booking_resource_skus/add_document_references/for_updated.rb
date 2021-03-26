# frozen_string_literal: true

module BookingResourceSkus
  module AddDocumentReferences
    class ForUpdated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.updated_booking_resource_skus
      end

      def price_info
        context.updated_booking_resource_skus_price_info
      end

      def action
        "modified"
      end
    end
  end
end
