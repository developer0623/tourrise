# frozen_string_literal: true

class ProductBookingResourceSkusController < ApplicationController
  def self.decorator_class
    BookingResourceSku
  end

  def index
    context = Products::LoadProductBookingResourceSkus.call(
      product_id: params[:product_id],
      filter: filter_params
    )

    respond_to do |format|
      format.html { load_index_context(context) }
      format.xlsx { load_xlsx_context(context) }
    end
  end

  private

  def load_index_context(context)
    @product_booking_resource_skus = ProductBookingResourceSkusDecorator.decorate(context.booking_resource_skus.page(params[:page]))
    @product = context.product
  end

  def load_xlsx_context(context)
    @booking_resource_skus = context.booking_resource_skus.decorate

    response.headers["Content-Disposition"] = "attachment; filename=\"resources-export-#{context.product.name}-#{Time.zone.now}.xlsx\""
  end

  def filter_params
    params.permit(
      :product_sku_id,
      :resource_ids
    )
  end
end
