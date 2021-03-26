# frozen_string_literal: true

module Documents
  module InitializeMainAttributes
    class Base
      include Interactor

      CONTEXT_ATTRIBUTES = %i[
        params
        booking
        booking_resource_skus
        booking_resource_sku_groups
        booking_credits
      ].freeze

      delegate(*CONTEXT_ATTRIBUTES, to: :context)

      def call
        context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?
        context.document = document_class.new(document_params)
      end

      private

      def document_class
        raise "Set document class!"
      end

      def document_params
        {
          booking: booking,
          booking_snapshot: booking,
          customer_snapshot: booking.customer,
          product_sku_snapshot: booking.product_sku,
          resource_skus_snapshot: booking.resource_skus,
          booking_resource_skus_snapshot: booking_resource_skus_snapshot,
          booking_resource_sku_groups_snapshot: booking_resource_sku_groups_snapshot,
          booking_credits_snapshot: booking_credits_snapshot
        }
      end

      def booking_resource_skus_snapshot
        booking_resource_skus&.map(&:serialize_for_snapshot)
      end

      def booking_resource_sku_groups_snapshot
        booking_resource_sku_groups&.map(&:serialize_for_snapshot)
      end

      def booking_credits_snapshot
        booking_credits&.map(&:serialize_for_snapshot)
      end
    end
  end
end
