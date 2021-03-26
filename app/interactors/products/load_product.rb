# frozen_string_literal: true

module Products
  class LoadProduct
    include Interactor

    def call
      product = Product.find_by_id(context.product_id)
      context.fail!(message: "Cannot find Product with id: #{context.product_id}") unless product.present?

      context.product = product
    end
  end
end
