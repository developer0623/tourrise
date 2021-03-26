# frozen_string_literal: true

module Api
  module V1
    class BookingResourceSkusController < Api::V1Controller
      def index
        respond_to do |format|
          format.csv { handle_csv }
        end
      end

      private

      def handle_csv
        context = GenerateProductResourceSkusCsvExport.call(product_sku_handle: params[:product_sku_handle], filter: filter_params)

        if context.success?
          send_data context.data, filename: "BookingResourceSkusExport-#{Date.today}.csv"
        else
          head context.message
        end
      end

      def filter_params
        {
          ends_on: params[:ends_on]
        }
      end
    end
  end
end
