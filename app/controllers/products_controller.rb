# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :load_product, only: %i[show edit update]

  def index
    @products = Products::ListProducts.call(page: params[:page], filter: filter_params, sort: sort_params).products
    @products = @products.decorate
  end

  def show; end

  def new
    @product = Product.new
    @product.product_skus.new unless @product.product_skus.any?

    @product = @product.decorate
  end

  def create
    context = Products::CreateProduct.call(params: product_params.to_h)
    if context.success?
      redirect_to product_path(context.product)
    else
      @product = context.product.decorate
      render "new", status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    context = Products::UpdateProduct.call(product: @product, params: product_params.to_h)
    if context.success?
      redirect_to product_path(context.product)
    else
      flash.now[:error] = context.message
      @product = context.product.decorate
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def load_product
    context = Products::LoadProduct.call(
      product_id: params[:id]
    )

    render_not_found && return unless context.success?

    @product = context.product.decorate
  end

  def product_params
    params.require(:product).permit!
  end

  def filter_params
    { q: params[:q] }
  end
end
