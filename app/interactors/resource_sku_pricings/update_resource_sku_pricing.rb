# frozen_string_literal: true

module ResourceSkuPricings
  class UpdateResourceSkuPricing
    include Interactor

    before do
      LoadResourceSkuPricing.call!(context)
    end

    def call
      context.fail!(message: context.resource_sku_pricing.errors.full_messages) unless context.resource_sku_pricing.update_attributes(context.params)
    end

    def resource_sku_pricing_params
      @resource_sku_pricing_params ||= prepare_params
    end
  end
end
