# frozen_string_literal: true

module Documents
  module Initialize
    class Positions
      include Interactor

      delegate :booking, to: :context

      def call
        validate_context

        load_booking_resource_skus
        load_booking_resource_sku_groups
        load_booking_credits
      end

      private

      def validate_context
        context.fail!(message: I18n.t("interactor_errors.empty", attribute: :booking)) if booking.blank?
      end

      def load_booking_resource_skus
        context.booking_resource_skus = BookingResourceSkus::Find.call(context).booking_resource_skus
      end

      def load_booking_resource_sku_groups
        context.booking_resource_sku_groups = BookingResourceSkuGroups::Find.call(context).booking_resource_sku_groups
      end

      def load_booking_credits
        context.booking_credits = BookingCredits::Find.call(context).booking_credits
      end
    end
  end
end
