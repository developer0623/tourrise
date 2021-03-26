# frozen_string_literal: true

module CsvExports
  class LoadPaymentData
    include Interactor

    SUPPORTED_SORT_BY_VALUES = %w[
      invoice_date
    ].freeze

    SUPPORTED_SORT_ORDER_VALUES = %w[
      asc
      desc
    ].freeze

    DEFAULT_SORT_DIR = "invoice_date"
    DEFAULT_SORT_ORDER = "asc"

    def call
      context.list_payments = list_payments
      context.invoice_date_options = invoice_date_options
    end

    private

    def all_data
      data = []

      Booking.booked.each do |booking|
        booking.booking_invoices.each do |invoice|
          PreparePaymentData.call(invoice: invoice).csv_data.each { |payment_data| data << payment_data }
        end
      end

      data
    end

    def invoice_date_options
      months_with_year = all_data.map { |payment| payment[:invoice_date].to_date.strftime("%B %Y") }.uniq
      options = []
      months_with_year.each do |month|
        options << [month.to_date, I18n.l(month.to_date, format: :month_and_year)]
      end

      options
    end

    def filter
      return false if context.filter.blank?

      filter = []

      context.filter.fetch(:invoice_date).split(",").each do |date_str|
        filter << date_str.to_date.strftime("%B %Y")
      end

      filter
    end

    def filtered_data(filter)
      data = []

      all_data.each do |payment|
        data << payment if filter.include?(payment[:invoice_date].to_date.strftime("%B %Y"))
      end

      data
    end

    def list_payments
      context.payment_data = payment_data

      sort_payments
    end

    def payment_data
      payments = filter ? filtered_data(filter) : all_data

      payments
    end

    def sort_by_column
      sort_by_invoice_date if context.sort_by == "invoice_date"
    end

    def sort_by_invoice_date
      context.payment_data = if context.sort_order == "asc"
                               context.payment_data.sort { |a, b| a[:invoice_date].to_date <=> b[:invoice_date].to_date }
                             else
                               context.payment_data.sort { |a, b| b[:invoice_date].to_date <=> a[:invoice_date].to_date }
                             end
    end

    def sort_payments
      return if context.sort.blank?

      context.sort_by = context.sort.fetch(:by, "")&.downcase || DEFAULT_SORT_DIR
      return unless SUPPORTED_SORT_BY_VALUES.include?(context.sort_by)

      context.sort_order = context.sort.fetch(:order, "ASC")&.downcase || DEFAULT_SORT_ORDER
      return unless SUPPORTED_SORT_ORDER_VALUES.include?(context.sort_order)

      sort_by_column
    end
  end
end
