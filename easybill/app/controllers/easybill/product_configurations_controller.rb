# frozen_string_literal: true

module Easybill
  class ProductConfigurationsController < ApplicationController
    before_action :set_product_configuration, only: %i[show update edit]

    def index
      @product_configurations = ProductConfiguration.all
    end

    def new
      @product_configuration = ProductConfiguration.new
    end

    def create
      @product_configuration = ProductConfiguration.new(product_configuration_params)
      if @product_configuration.save
        flash[:success] = "Prduct configuration created"
        redirect_to product_configurations_path
      else
        flash[:error] = @product_configuration.errors.full_messages
        render "new", status: :unprocessable_entity
      end
    end

    def show; end

    def edit; end

    def update
      if @product_configuration.update(product_configuration_params)
        flash[:success] = "Product configuration updated"
        redirect_to product_configurations_path
      else
        flash[:error] = @product_configuration.errors.full_messages
        render "edit", status: :unprocessable_entity
      end
    end

    private

    def set_product_configuration
      @product_configuration = ProductConfiguration.find(params[:id])
    end

    def product_configuration_params
      params.require(:product_configuration).permit(:product_id, :offer_template, :invoice_template)
    end
  end
end
