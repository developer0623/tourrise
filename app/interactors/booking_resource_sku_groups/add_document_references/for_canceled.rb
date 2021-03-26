# frozen_string_literal: true

module BookingResourceSkuGroups
  module AddDocumentReferences
    class ForCanceled < Documents::AddDocumentReferences::Base
      private

      def collection
        context.canceled_booking_resource_sku_groups
      end

      def price_info
        context.canceled_booking_resource_sku_groups_price_info
      end

      def action
        "canceled"
      end
    end
  end
end
