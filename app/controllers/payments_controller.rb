# frozen_string_literal: true

class PaymentsController < ApplicationController
  def index
    context = CsvExports::LoadPaymentData.call(
      filter: params.permit(:invoice_date),
      sort: sort_params,
      page: params[:page]
    )

    respond_to do |format|
      format.html { load_index_context(context) }
      format.csv { payments_csv_file(context) }
    end
  end

  private

  def load_index_context(context)
    @payments = context.list_payments
    @options = context.invoice_date_options
  end

  def payments_csv_file(context)
    csv_context = CsvExports::GeneratePaymentsCsvExport.call(payments: context.list_payments)

    if csv_context.success?
      send_data csv_context.csv, filename: filename(csv_context)
    else
      redirect_to settings_path
    end
  end

  def filename(csv_context)
    time_range = csv_context.payments.map { |payment| I18n.l(payment[:due_on].to_date, format: "%B%y") }.uniq

    "#{Time.zone.today.strftime('%Y%m%d')}-#{Payment.model_name.human(count: 2)}-#{time_range.first}-#{time_range.last}.csv"
  end
end
