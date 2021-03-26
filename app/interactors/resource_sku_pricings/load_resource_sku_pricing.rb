# frozen_string_literal: true

module ResourceSkuPricings
  class LoadResourceSkuPricing
    include Interactor

    def call
      context.resource_sku_pricing = ResourceSkuPricing.find_by_id(context.resource_sku_pricing_id)

      context.fail!(message: :not_found) unless context.resource_sku_pricing.present?
    end
  end
end
