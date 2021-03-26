# frozen_string_literal: true

module Easybill
  class CancelInvoice < InteractorBase
    def call
      invoice = context.invoice

      invoice.cancel!

      context.invoice = invoice
    end
  end
end
