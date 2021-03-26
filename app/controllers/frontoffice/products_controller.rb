# frozen_string_literal: true

module Frontoffice
  class ProductsController < FrontofficeController
    def index
      @products = Product.published
    end

    def show
      @product = Product.published.includes(:product_skus).where(product_skus: { handle: params[:sku_handle] }).first!
    end
  end
end
