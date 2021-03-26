# frozen_string_literal: true

module BookingResourceSkuGroups
  class CollectForDocument
    include Interactor

    delegate :created_booking_resource_sku_groups, :updated_booking_resource_sku_groups, :canceled_booking_resource_sku_groups, to: :context

    def call
      context.booking_resource_sku_groups = booking_resource_sku_groups
    end

    private

    def booking_resource_sku_groups
      created_booking_resource_sku_groups + updated_booking_resource_sku_groups + canceled_booking_resource_sku_groups
    end
  end
end
