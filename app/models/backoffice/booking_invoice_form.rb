# frozen_string_literal: true

module Backoffice
  class BookingInvoiceForm
    attr_reader :created_booking_resource_skus,
                :updated_booking_resource_skus,
                :canceled_booking_resource_skus,
                :created_booking_resource_sku_groups,
                :updated_booking_resource_sku_groups,
                :canceled_booking_resource_sku_groups,
                :created_booking_credits,
                :updated_booking_credits,
                :removed_booking_credits,
                :created_booking_resource_skus_price_info,
                :updated_booking_resource_skus_price_info,
                :canceled_booking_resource_skus_price_info,
                :created_booking_resource_sku_groups_price_info,
                :updated_booking_resource_sku_groups_price_info,
                :canceled_booking_resource_sku_groups_price_info,
                :created_booking_credits_price_info,
                :updated_booking_credits_price_info,
                :removed_booking_credits_price_info

    def self.from_interactor_context(context)
      new(
        created_booking_resource_skus: context.created_booking_resource_skus,
        updated_booking_resource_skus: context.updated_booking_resource_skus,
        canceled_booking_resource_skus: context.canceled_booking_resource_skus,
        created_booking_resource_sku_groups: context.created_booking_resource_sku_groups,
        updated_booking_resource_sku_groups: context.updated_booking_resource_sku_groups,
        canceled_booking_resource_sku_groups: context.canceled_booking_resource_sku_groups,
        created_booking_credits: context.created_booking_credits,
        updated_booking_credits: context.updated_booking_credits,
        removed_booking_credits: context.removed_booking_credits,
        created_booking_resource_skus_price_info: context.created_booking_resource_skus_price_info,
        updated_booking_resource_skus_price_info: context.updated_booking_resource_skus_price_info,
        canceled_booking_resource_skus_price_info: context.canceled_booking_resource_skus_price_info,
        created_booking_resource_sku_groups_price_info: context.created_booking_resource_sku_groups_price_info,
        updated_booking_resource_sku_groups_price_info: context.updated_booking_resource_sku_groups_price_info,
        canceled_booking_resource_sku_groups_price_info: context.canceled_booking_resource_sku_groups_price_info,
        created_booking_credits_price_info: context.created_booking_credits_price_info,
        updated_booking_credits_price_info: context.updated_booking_credits_price_info,
        removed_booking_credits_price_info: context.removed_booking_credits_price_info
      )
    end

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def booking_resource_skus
      created_booking_resource_skus + updated_booking_resource_skus + canceled_booking_resource_skus
    end

    def booking_resource_sku_groups
      created_booking_resource_sku_groups + updated_booking_resource_sku_groups + canceled_booking_resource_sku_groups
    end

    def booking_credits
      created_booking_credits + updated_booking_credits + removed_booking_credits
    end
  end
end
