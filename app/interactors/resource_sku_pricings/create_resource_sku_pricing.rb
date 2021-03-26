# frozen_string_literal: true

module ResourceSkuPricings
  class CreateResourceSkuPricing
    include Interactor

    before do
      ResourceSkus::LoadResourceSku.call(context)
    end

    def call
      context.resource_sku_pricing = ResourceSkuPricing.new(resource_sku_pricing_params)

      context.fail!(message: context.resource_sku_pricing.errors.full_messages) unless context.resource_sku_pricing.save
    end

    private

    def resource_sku_pricing_params
      context.params.merge("resource_sku" => context.resource_sku)
    end
  end
end
