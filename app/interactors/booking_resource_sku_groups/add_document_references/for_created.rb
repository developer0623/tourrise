# frozen_string_literal: true

module BookingResourceSkuGroups
  module AddDocumentReferences
    class ForCreated < Documents::AddDocumentReferences::Base
      private

      def collection
        context.created_booking_resource_sku_groups
      end

      def price_info
        context.created_booking_resource_sku_groups_price_info
      end

      def action
        "added"
      end
    end
  end
end
