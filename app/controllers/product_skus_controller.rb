# frozen_string_literal: true

class ProductSkusController < ApplicationController
  before_action :load_product, only: %i[edit update destroy]
  before_action :load_product_sku, only: %i[edit update destroy]

  def edit
    @product_sku.build_product_sku_booking_configuration if @product_sku.product_sku_booking_configuration.blank?
  end

  def update
    if @product_sku.update(product_sku_params)
      flash[:success] = I18n.t("product_skus.update.success")
      redirect_to product_path(@product)
    else
      flash[:error] = @product_sku.errors.full_messages
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = ProductSkus::DestroyProductSku.call(product_id: params[:product_id], product_sku_id: params[:id])

    if context.success?
      flash[:success] = I18n.t("product_skus.destroy.success")
    else
      flash[:error] = context.message
    end

    redirect_to request.referer
  end

  private

  def load_product
    context = Products::LoadProduct.call(product_id: params[:product_id])

    render_not_found && return unless context.success?

    @product = context.product
  end

  def load_product_sku
    @product_sku = @product.product_skus.find(params[:id])
  end

  def product_sku_params
    params.require(:product_sku).permit(
      :name,
      :handle,
      :financial_account_id,
      :cost_center_id,
      product_sku_booking_configuration_attributes: %i[id starts_on ends_on default_destination_airport_code wishyouwhat_on_first_step _destroy]
    )
  end
end
