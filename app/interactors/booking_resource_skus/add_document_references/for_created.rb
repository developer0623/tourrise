# frozen_string_literal: true

module BookingResourceSkus
  module AddDocumentReferences
    class ForCreated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.created_booking_resource_skus
      end

      def price_info
        context.created_booking_resource_skus_price_info
      end

      def action
        "added"
      end
    end
  end
end
