# frozen_string_literal: true

module Settings
  class CostCentersController < ApplicationController
    def index
      @cost_centers = CostCenter.all
    end

    def new
      @cost_center = CostCenter.new
    end

    def create
      @cost_center = CostCenter.new(cost_center_params)

      if @cost_center.save
        redirect_to settings_cost_centers_path
      else
        render "new", status: :unprocessable_entity
      end
    end

    def edit
      @cost_center = CostCenter.find(params[:id])
    end

    def update
      @cost_center = CostCenter.find(params[:id])

      if @cost_center.update(cost_center_params)
        redirect_to settings_cost_centers_path
      else
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def cost_center_params
      params.require(:cost_center).permit(
        :name,
        :value
      )
    end
  end
end
