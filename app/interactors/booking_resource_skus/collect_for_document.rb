# frozen_string_literal: true

module BookingResourceSkus
  class CollectForDocument
    include Interactor

    delegate :created_booking_resource_skus, :updated_booking_resource_skus, :canceled_booking_resource_skus, to: :context

    def call
      context.booking_resource_skus = booking_resource_skus
    end

    private

    def booking_resource_skus
      created_booking_resource_skus + updated_booking_resource_skus + canceled_booking_resource_skus
    end
  end
end
