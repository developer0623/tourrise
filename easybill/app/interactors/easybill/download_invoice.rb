# frozen_string_literal: true

module Easybill
  class DownloadInvoice
    include Interactor

    def call
      load_invoice

      document = download_document

      context.document = document
    end

    private

    def load_invoice
      invoice = Invoice.find_by(id: context.invoice_id)
      context.fail!(message: :invoice_not_found) unless invoice.present?

      context.invoice = invoice
    end

    def download_document
      document = Easybill::ApiService.new.download_document(context.invoice.external_id)

      context.fail!(invoice: context.invoice, message: :document_not_found) unless document.present?
      document
    end
  end
end
