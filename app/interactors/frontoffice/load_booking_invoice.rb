# frozen_string_literal: true

module Frontoffice
  class LoadBookingInvoice < LoadBookingDocument
    before :load_booking

    def call
      context.booking_invoice = context.booking.booking_invoices.find_by(scrambled_id: context.invoice_scrambled_id)

      context.fail!(message: :not_found) unless context.booking_invoice.present?
    end
  end
end
