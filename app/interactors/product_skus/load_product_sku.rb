# frozen_string_literal: true

module ProductSkus
  class LoadProductSku
    include Interactor

    def call
      context.product_sku = ProductSku.all.find_by(id: context.product_sku_id)

      context.fail!(message: :not_found) if context.product_sku.blank?
    end
  end
end
