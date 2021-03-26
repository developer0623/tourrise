# frozen_string_literal: true

class InventoriesController < ApplicationController
  def index
    inventories = Inventories::ListInventories.call(page: params[:page],
                                                    filter: filter_params,
                                                    sort: sort_params).inventories

    @inventories = inventories.decorate
  end

  def show
    @inventory = Inventory.find(params[:id]).decorate
    @resource_skus = Inventories::ListResourceSkus.call(inventory_id: params[:id]).resource_skus.decorate

    respond_to do |format|
      format.html
      format.js
      format.csv { send_data @inventory.to_csv, filename: "#{@inventory.name.parameterize}-#{Date.today}.csv" }
    end
  end

  def new
    @inventory = Inventory.new
    @inventory.availabilities.new unless @inventory.availabilities.any?
  end

  def create
    @inventory = Inventory.new(inventory_params)

    if @inventory.save
      flash[:success] = I18n.t("inventories.create.success")
      redirect_to inventory_path(@inventory)
    else
      flash[:error] = I18n.t("inventories.create.error")
      render "new", status: :unprocessable_entity
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
    @inventory.availabilities.new unless @inventory.availabilities.any?
  end

  def update
    @inventory = Inventory.find(params[:id])

    if @inventory.update(inventory_params)
      flash[:success] = I18n.t("inventories.update.success")
      redirect_to inventory_path(@inventory)
    else
      flash[:error] = @inventory.errors.full_messages
      render "edit", status: :unprocessable_entity
    end
  end

  private

  def inventory_params
    params.require(:inventory).permit(
      :name,
      :description,
      :inventory_type,
      availabilities_attributes: %i[id quantity starts_on ends_on _destroy]
    )
  end

  def filter_params
    { q: params[:q] }
  end
end
