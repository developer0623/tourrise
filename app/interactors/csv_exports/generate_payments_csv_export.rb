# frozen_string_literal: true

module CsvExports
  class GeneratePaymentsCsvExport
    include Interactor

    def call
      context.csv = generate_csv
    end

    private

    def generate_csv
      CSV.generate(headers: true, col_sep: ";") do |csv|
        csv << headers

        context.payments.each { |payment_data| csv << payment_data.values }
      end
    end

    def headers
      [
        Booking.model_name.human,
        I18n.t("settings.accounting_records.table_headers.customer"),
        I18n.t("settings.accounting_records.table_headers.customer_id"),
        I18n.t("settings.accounting_records.table_headers.product"),
        I18n.t("settings.accounting_records.table_headers.product_sku"),
        I18n.t("settings.accounting_records.table_headers.amount"),
        I18n.t("settings.accounting_records.table_headers.booking_starts_on"),
        I18n.t("settings.accounting_records.table_headers.financial_account"),
        I18n.t("settings.accounting_records.table_headers.cost_center"),
        I18n.t("settings.accounting_records.table_headers.payment_due_on"),
        I18n.t("settings.accounting_records.table_headers.invoice_number"),
        I18n.t("settings.accounting_records.table_headers.invoice_date")
      ].freeze
    end
  end
end
