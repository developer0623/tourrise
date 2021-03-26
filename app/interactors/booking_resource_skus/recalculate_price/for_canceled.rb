# frozen_string_literal: true

module BookingResourceSkus
  module RecalculatePrice
    class ForCanceled
      include Interactor

      delegate :canceled_booking_resource_skus, :document_type, to: :context

      def call
        context.canceled_booking_resource_skus_price_info = canceled_booking_resource_skus_price_info
      end

      private

      def canceled_booking_resource_skus_price_info
        canceled_booking_resource_skus.each_with_object({}) do |canceled_booking_resource_sku, info|
          info[canceled_booking_resource_sku.id] = info_for_booking_resource_sku(canceled_booking_resource_sku)
        end
      end

      def info_for_booking_resource_sku(booking_resource_sku)
        previous_item = get_previous_item(booking_resource_sku)

        { total_price: - previous_item.total_price }
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
