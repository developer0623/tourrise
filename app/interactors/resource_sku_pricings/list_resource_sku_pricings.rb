# frozen_string_literal: true

module ResourceSkuPricings
  class ListResourceSkuPricings
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      id
      price_cents
      participant_type
      calculation_type
      starts_on
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "id"
    DEFAULT_SORT_ORDER = "asc"

    before do
      ResourceSkus::LoadResourceSku.call!(context)
    end

    def call
      context.resource_sku_pricings = context.resource_sku.resource_sku_pricings

      sort
    end

    private

    def sort
      context.sort_by = context.sort&.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort&.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      context.resource_sku_pricings = context.resource_sku_pricings.order(context.sort_by => context.sort_order)
    end
  end
end
