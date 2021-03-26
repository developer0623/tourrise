# frozen_string_literal: true

class SeasonsController < ApplicationController
  def new
    context = Products::LoadProduct.call(product_id: params[:product_id])

    if context.success?
      @season = context.product.seasons.new
    else
      render_not_found
    end
  end

  def create
    context = Seasons::CreateSeason.call(params: season_params.to_h, product_id: params[:product_id])

    if context.success?
      redirect_to product_path(params[:product_id])
    else
      @season = context.season
      flash.now[:error] = context.message
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    context = Seasons::LoadSeason.call(season_id: params[:id])

    if context.success?
      @season = context.season
    else
      flash.now[:error] = context.message
      render_not_found
    end
  end

  def update
    context = Seasons::UpdateSeason.call(params: season_params.to_h, season_id: params[:id])

    if context.success?
      redirect_to product_path(context.season.product)
    else
      @season = context.season
      flash.now[:error] = context.message
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    context = Seasons::DeleteSeason.call(season_id: params[:id])

    flash[:error] = context.message if context.failure?

    redirect_to product_path(context.season.product_id)
  end

  private

  def season_params
    params.require(:season).permit(
      :name,
      :published_at,
      seasonal_product_skus_attributes: %i[id enabled product_sku_id starts_on ends_on _destroy]
    )
  end
end
