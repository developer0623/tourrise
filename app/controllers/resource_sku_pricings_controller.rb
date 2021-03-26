# frozen_string_literal: true

class ResourceSkuPricingsController < ApplicationController
  decorates_assigned :resource_sku_pricing
  decorates_assigned :resource_sku_pricings

  def new
    @resource_sku_pricing = ResourceSkuPricing.new(resource_sku_id: params[:resource_sku_id])
  end

  def create
    context = ResourceSkuPricings::CreateResourceSkuPricing.call(
      resource_sku_id: params[:resource_sku_id],
      params: permitted_params
    )

    if context.success?
      flash[:info] = context.message
      redirect_to bulk_edit_resource_sku_resource_sku_pricings_path(params[:resource_sku_id])
    else
      flash.now[:error] = context.message
      @resource_sku_pricing = context.resource_sku_pricing
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @resource_sku_pricing = ResourceSkuPricing.find(params[:id])
  end

  def update
    context = ResourceSkuPricings::UpdateResourceSkuPricing.call(
      resource_sku_pricing_id: params[:id],
      params: permitted_params
    )

    if context.success?
      flash[:info] = context.message
      redirect_to bulk_edit_resource_sku_resource_sku_pricings_path(context.resource_sku_pricing.resource_sku)
    else
      flash.now[:error] = context.message
      @resource_sku_pricing = context.resource_sku_pricing
      render "edit", status: :unprocessable_entity
    end
  end

  def bulk_edit
    context = ResourceSkuPricings::ListResourceSkuPricings.call(
      resource_sku_id: params[:resource_sku_id],
      start_date: params[:start_date],
      sort: sort_params
    )

    if context.success?
      @resource_sku = context.resource_sku
      @resource_sku_pricings = context.resource_sku_pricings

      respond_to do |format|
        format.html
        format.js
      end
    else
      flash[:error] = context.message
      redirect_to request.referer
    end
  end

  def destroy
    resource_sku_pricing = ResourceSkuPricing.find_by(id: params[:id])

    redirect_to request.referer if resource_sku_pricing.blank?

    if resource_sku_pricing.destroy
      flash[:success] = I18n.t("resource_sku_pricings.destroy.success")
    else
      flash[:error] = resource_sku_pricing.errors.full_messages
    end

    redirect_to request.referer
  end

  private

  def permitted_params
    params
      .require(:resource_sku_pricing)
      .permit(
        :price,
        :participant_type,
        :calculation_type,
        :single_day,
        :starts_on,
        :ends_on,
        consecutive_days_ranges_attributes: %i[price from to id _destroy]
      )
  end
end
