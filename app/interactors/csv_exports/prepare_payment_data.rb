# frozen_string_literal: true

module CsvExports
  class PreparePaymentData
    include Interactor

    delegate :invoice, to: :context

    before do
      context.csv_data = []
    end

    def call
      return unless invoice.payments.any?

      accounting1, accounting2 = payments_csv_export_service.accounting_data

      push_to_csv_data(accounting1, partial_payment_due_on)
      push_to_csv_data(accounting2, final_payment_due_on)

      booking_credits_to_csv_data
    end

    private

    def booking_credits_to_csv_data
      invoice.booking_credits_snapshot.each do |credit|
        context.csv_data << payments_csv_export_service.update_csv(
          payments_csv_export_service.financial_account(credit),
          payments_csv_export_service.cost_center(credit),
          invoice.created_at.to_date,
          -credit["price_cents"] / 100.00
        )
      end
    end

    def push_to_csv_data(accounting_hash, due_on)
      accounting_hash.each do |cost_center, financial_accounts|
        financial_accounts.each do |financial_account, amount|
          context.csv_data << payments_csv_export_service.update_csv(financial_account, cost_center, due_on, amount)
        end
      end
    end

    def payments_csv_export_service
      @payments_csv_export_service ||= PaymentsCsvExportService.new(invoice)
    end

    def partial_payment_due_on
      invoice.payments.first.due_on
    end

    def final_payment_due_on
      invoice.payments.last.due_on
    end
  end
end
