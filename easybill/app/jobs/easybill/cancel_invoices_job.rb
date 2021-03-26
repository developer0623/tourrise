# frozen_string_literal: true

module Easybill
  class CancelInvoicesJob < EasybillJob
    def perform(booking_data)
      easybill_invoices = load_easybill_invoices(booking_data["id"])

      easybill_invoices.each do |invoice|
        CancelInvoice.call(invoice: invoice)
      end
    end

    def load_easybill_invoices(booking_id)
      booking_invoice_ids = BookingInvoice.where(booking_id: booking_id).pluck(:id)
      return [] if booking_invoice_ids.empty?

      ::Easybill::Invoice.active.where(booking_invoice_id: booking_invoice_ids)
    end
  end
end
