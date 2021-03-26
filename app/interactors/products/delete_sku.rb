# frozen_string_literal: true

module Products
  class DeleteSku
    include Interactor

    def call
      load_product

      sku = context.product.skus.find_by_id(context.sku_id)
      context.fail!(message: "Cannot destroy Sku with id: #{context.sku_id}") unless sku.destroy

      true
    end

    private

    def load_product
      product_context = LoadProduct.call(product_id: context.product_id)

      context.fail!(message: product_context.message) if product_context.failure?

      context.product = product_context.product
    end
  end
end
