# frozen_string_literal: true

module Easybill
  class InvoicesController < ApplicationController
    def show
      context = DownloadInvoice.call(invoice_id: params[:id])

      return unless context.success?

      respond_to do |format|
        format.pdf do
          send_pdf_data(context.document, "Rechnung.pdf")
        end
      end
    end
  end
end
