# frozen_string_literal: true

module Frontoffice
  class BookingInvoiceDecorator < BookingDocumentDecorator
    def payments
      object.payments.decorate
    end

    private

    def easybill_document
      ::Easybill::Invoice.find_by(booking_invoice: object)
    end
  end
end
