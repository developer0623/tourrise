# frozen_string_literal: true

class ResourceSkusController < ApplicationController
  decorates_assigned :resource_sku

  def show
    load_resource_sku
  end

  def edit
    load_resource_sku
  end

  def update
    context = ResourceSkus::UpdateResourceSku.call(
      resource_sku_id: params[:id],
      params: resource_sku_params.to_h
    )

    if context.success?
      redirect_to resource_path(context.resource_sku.resource_id)
    else
      @resource_sku = context.resource_sku
      flash[:error] = context.message
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = ResourceSkus::DestroyResourceSku.call(resource_sku_id: params[:id])

    if context.success?
      redirect_to resource_path(context.resource_sku.resource_id)
    else
      @resource_sku = context.resource_sku
      flash.now[:error] = context.message
      render "show", status: :unprocessable_entity
    end
  end

  private

  def resource_sku_params
    params.require(:resource_sku).permit!
  end

  def load_resource_sku
    context = ResourceSkus::LoadResourceSku.call(resource_sku_id: params[:id])

    if context.success?
      @resource_sku = context.resource_sku
    else
      flash.now[:error] = context.message
      render "errors/404"
    end
  end
end
