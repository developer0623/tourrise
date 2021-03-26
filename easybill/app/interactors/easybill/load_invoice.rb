# frozen_string_literal: true

module Easybill
  class LoadInvoice
    include Interactor

    def call
      context.invoice = Invoice.find_by_booking_invoice_id(context.booking_invoice_id)

      fail_with_not_found_message if context.invoice.blank?
    end

    private

    def fail_with_not_found_message
      context.fail!(message: "No easybill invoice found for #{context.booking_invoice_id}")
    end
  end
end
