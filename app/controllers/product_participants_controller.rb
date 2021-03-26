# frozen_string_literal: true

class ProductParticipantsController < ApplicationController
  def index
    context = Products::LoadProductParticipants.call(
      product_id: params[:product_id],
      filter: filter_params,
      sort_by: params[:sort_by],
      sort_dir: params[:sort_order],
      page: params[:page]
    )

    respond_to do |format|
      format.html { load_index_context(context) }
      format.csv { send_csv_file(context) }
    end
  end

  private

  def filter_params
    params.permit(:product_sku_id)
  end

  def load_index_context(context)
    @booking_participants = context.booking_participants.decorate
    @product = context.product
  end

  def send_csv_file(context)
    csv_context = CsvExports::GenerateProductParticipantsCsvExport.call(context)

    if csv_context.success?
      send_data context.csv, filename: "booking_participants-#{Date.today}.csv"
    else
      redirect_to request.referer
    end
  end
end
