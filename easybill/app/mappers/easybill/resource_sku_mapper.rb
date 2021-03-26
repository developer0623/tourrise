# frozen_string_literal: true

module Easybill
  class ResourceSkuMapper
    DEFAULT_PRICE_TYPE = "BRUTTO"

    class << self
      def to_easybill_position(resource_sku)
        {
          number: resource_sku.handle,
          description: resource_sku.name,
          price_type: DEFAULT_PRICE_TYPE,
          vat_percent: resource_sku.vat,
          sale_price: resource_sku.price.cents
        }
      end
    end
  end
end
