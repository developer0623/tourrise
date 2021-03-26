# frozen_string_literal: true

module BookingResourceSkus
  class LoadBookingResourceSku
    include Interactor

    def call
      context.booking_resource_sku = BookingResourceSku.find_by_id(context.booking_resource_sku_id)

      context.fail!(message: I18n.t("errors.not_found")) unless context.booking_resource_sku.present?
    end
  end
end
