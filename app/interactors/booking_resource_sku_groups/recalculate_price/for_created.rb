# frozen_string_literal: true

module BookingResourceSkuGroups
  module RecalculatePrice
    class ForCreated
      include Interactor

      delegate :created_booking_resource_sku_groups, to: :context

      def call
        context.created_booking_resource_sku_groups_price_info = created_booking_resource_sku_groups_price_info
      end

      private

      def created_booking_resource_sku_groups_price_info
        created_booking_resource_sku_groups.each_with_object({}) do |booking_resource_sku_group, info|
          info[booking_resource_sku_group.id] = info_for_booking_resource_sku(booking_resource_sku_group)
        end
      end

      def info_for_booking_resource_sku(booking_resource_sku_group)
        { total_price: booking_resource_sku_group.price }
      end
    end
  end
end
