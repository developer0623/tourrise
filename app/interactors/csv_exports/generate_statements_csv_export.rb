# frozen_string_literal: true

module CsvExports
  class GenerateStatementsCsvExport
    include Interactor

    HEADERS = %w[
      Rechnungsnummer
      Rechnungsempfänger
      Reise
      Beginn
      Ende
      Betrag
      Currency
    ].freeze

    delegate :booking_invoices, to: :context
    def call
      context.csv = generate_csv
    end

    private

    def generate_csv
      CSV.generate(headers: true, col_sep: ";") do |csv|
        csv << HEADERS

        booking_invoices.includes(booking: [:customer]).each do |invoice|
          csv << [
            invoice.number,
            [invoice.booking.customer.object.first_name, invoice.booking.customer.object.last_name].join(" "),
            invoice.booking.title,
            invoice.booking.starts_on.iso8601,
            invoice.booking.ends_on.iso8601,
            invoice.total_price,
            invoice.total_price.currency
          ]
        end
      end
    end
  end
end
