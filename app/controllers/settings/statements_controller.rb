# frozen_string_literal: true

module Settings
  class StatementsController < ApplicationController
    def index
      @booking_invoices = BookingInvoice.where("created_at > ? AND created_at < ?", beginning_of_month, end_of_month).decorate

      respond_to do |format|
        format.html { @options = month_filter_options }
        format.csv { statements_csv_file }
      end
    end

    private

    def beginning_of_month
      if params[:month_and_year].present?
        Time.zone.parse(params[:month_and_year])
      else
        Time.zone.now
      end.beginning_of_month
    end

    def end_of_month
      if params[:month_and_year].present?
        Time.zone.parse(params[:month_and_year])
      else
        Time.zone.now
      end.end_of_month
    end

    def statements_csv_file
      context = CsvExports::GenerateStatementsCsvExport.call(booking_invoices: @booking_invoices)

      if context.success?
        send_data context.csv, filename: filename
      else
        redirect_to settings_path
      end
    end

    def filename
      time = @booking_invoices.first.created_at.strftime("%B%y")

      "statements-#{time}.csv"
    end

    def month_filter_options
      months_with_year = BookingInvoice.all.order(created_at: :desc).pluck(:created_at).map { |date| date.to_date.strftime("%B %Y") }.uniq

      options = []
      months_with_year.each do |month|
        options << [month.to_date, I18n.l(month.to_date, format: "%B %Y")]
      end

      options
    end
  end
end
