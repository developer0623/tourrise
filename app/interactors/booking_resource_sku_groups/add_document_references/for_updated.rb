# frozen_string_literal: true

module BookingResourceSkuGroups
  module AddDocumentReferences
    class ForUpdated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.updated_booking_resource_sku_groups
      end

      def price_info
        context.updated_booking_resource_sku_groups_price_info
      end

      def action
        "modified"
      end
    end
  end
end
