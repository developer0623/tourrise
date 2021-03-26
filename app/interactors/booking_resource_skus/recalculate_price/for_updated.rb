# frozen_string_literal: true

module BookingResourceSkus
  module RecalculatePrice
    class ForUpdated
      include Interactor

      delegate :updated_booking_resource_skus, :document_type, to: :context

      def call
        context.updated_booking_resource_skus_price_info = updated_booking_resource_skus_price_info
      end

      private

      def updated_booking_resource_skus_price_info
        updated_booking_resource_skus.each_with_object({}) do |updated_booking_resource_sku, info|
          info[updated_booking_resource_sku.id] = info_for_booking_resource_sku(updated_booking_resource_sku)
        end
      end

      def info_for_booking_resource_sku(booking_resource_sku)
        previous_item = get_previous_item(booking_resource_sku)

        prices_info_for_versions(previous_item, booking_resource_sku)
      end

      def prices_info_for_versions(previous_item, booking_resource_sku)
        previous_price = previous_item.total_price
        current_price = booking_resource_sku.total_price
        total_price = current_price - previous_price

        {
          current_price: current_price,
          previous_price: previous_price,
          total_price: total_price
        }
      end

      def get_previous_item(booking_resource_sku)
        last_reference = last_reference_for(booking_resource_sku)
        referenced_version = PaperTrail::Version.find(last_reference.item_version_id)
        referenced_version.reify_version
      end

      def last_reference_for(booking_resource_sku)
        booking_resource_sku.document_references.where(document_type: document_type).last
      end
    end
  end
end
