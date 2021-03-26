# frozen_string_literal: true

module ProductSkus
  class ListProductSkus
    include Interactor

    def call
      context.product_skus = ProductSku.with_translations(I18n.locale).joins(:product).merge(Product.with_translations(I18n.locale))

      sort_product_skus
    end

    def sort_product_skus
      context.product_skus = context.product_skus.order("product_translations.name", "product_sku_translations.name")
    end
  end
end
