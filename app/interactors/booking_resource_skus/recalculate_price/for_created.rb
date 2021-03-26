# frozen_string_literal: true

module BookingResourceSkus
  module RecalculatePrice
    class ForCreated
      include Interactor

      delegate :created_booking_resource_skus, to: :context

      def call
        context.created_booking_resource_skus_price_info = created_booking_resource_skus_price_info
      end

      private

      def created_booking_resource_skus_price_info
        created_booking_resource_skus.each_with_object({}) do |created_booking_resource_sku, info|
          info[created_booking_resource_sku.id] = info_for_booking_resource_sku(created_booking_resource_sku)
        end
      end

      def info_for_booking_resource_sku(booking_resource_sku)
        { total_price: booking_resource_sku.total_price }
      end
    end
  end
end
