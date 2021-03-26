# frozen_string_literal: true

module BookingResourceSkus
  class SaveBookingResourceSku
    include Interactor

    def call
      context.fail!(message: context.booking_resource_sku.errors.full_messages) unless context.booking_resource_sku.save
    end
  end
end
