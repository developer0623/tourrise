# frozen_string_literal: true

class AvailabilitiesController < ApplicationController
  # you can acces this view helper inventory_day_view_path(inventory, year, month, day)
  def day_view
    @availabilities = Availability.where(inventory_id: params[:inventory_id]).decorate
    @date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)
  end

  def show
    @availability = Availability.find(params[:id]).decorate
  end
end
