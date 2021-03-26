# frozen_string_literal: true

module Frontoffice
  class BookingInvoicesController < FrontofficeController
    decorates_assigned :booking_invoice, with: Frontoffice::BookingInvoiceDecorator

    def show
      load_booking_invoice
    end

    private

    def load_booking_invoice
      context = LoadBookingInvoice.call(
        booking_scrambled_id: params[:booking_scrambled_id],
        invoice_scrambled_id: params[:scrambled_id]
      )
      if context.success?
        @booking_invoice = context.booking_invoice
      else
        render_not_found
      end
    end
  end
end
