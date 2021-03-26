# frozen_string_literal: true

module BookingResourceSkuGroups
  module RecalculatePrice
    class ForUpdated
      include Interactor

      delegate :updated_booking_resource_sku_groups, :document_type, to: :context

      def call
        context.updated_booking_resource_sku_groups_price_info = updated_booking_resource_sku_groups_price_info
      end

      private

      def updated_booking_resource_sku_groups_price_info
        updated_booking_resource_sku_groups.each_with_object({}) do |booking_resource_sku_group, info|
          info[booking_resource_sku_group.id] = info_for_booking_resource_sku(booking_resource_sku_group)
        end
      end

      def info_for_booking_resource_sku(booking_resource_sku_group)
        previous_item = get_previous_item(booking_resource_sku_group)

        prices_info_for_versions(previous_item, booking_resource_sku_group)
      end

      def prices_info_for_versions(previous_item, booking_resource_sku_group)
        previous_price = previous_item.price
        current_price = booking_resource_sku_group.price
        total_price = current_price - previous_price

        {
          current_price: current_price,
          previous_price: previous_price,
          total_price: total_price
        }
      end

      def get_previous_item(booking_resource_sku_group)
        last_reference = last_reference_for(booking_resource_sku_group)
        referenced_version = PaperTrail::Version.find(last_reference.item_version_id)
        referenced_version.reify_version
      end

      def last_reference_for(booking_resource_sku_group)
        booking_resource_sku_group.document_references.where(document_type: document_type).last
      end
    end
  end
end
