# frozen_string_literal: true

module Easybill
  class CreateInvoiceJob < EasybillJob
    def perform(invoice_data)
      context = CreateInvoice.call(data: invoice_data)

      return true if context.success?

      raise "CreateInvoice failed with: #{context.error}" unless context.error == :easybill_customer_not_created

      create_customer(context.booking)
      retry_later(invoice_data)
    end

    private

    def create_customer(booking)
      CreateCustomerJob.perform_later(
        booking.customer.as_json(only: %i[id])
      )
    end

    def retry_later(invoice_data)
      self.class.set(wait: 5.seconds).perform_later(invoice_data)
    end
  end
end
