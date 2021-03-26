# frozen_string_literal: true

module Frontoffice
  class LoadProductSku
    include Interactor

    def call
      context.product_sku = ProductSku.published.find_by(handle: context.product_sku_handle)

      context.fail!(message: :not_found) if context.product_sku.blank?
    end
  end
end
