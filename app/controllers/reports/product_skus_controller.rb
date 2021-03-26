# frozen_string_literal: true

module Reports
  class ProductSkusController < ApplicationController
    def index
      context = LoadProductSkus.call(filter: filter_params)

      if context.success?
        @product_skus = ProductSkuReportDecorator.decorate_collection(context.product_skus, context: { season_ids: context.season_ids })
      else
        flash[:error] = context.message
        redirect_to reports_path
      end
    end

    private

    def filter_params
      params.permit(:season, :resource_id).to_h
    end
  end
end
