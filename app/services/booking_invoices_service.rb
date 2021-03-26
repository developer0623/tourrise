# frozen_string_literal: true

class BookingInvoicesService < BookingDocumentsServiceBase
  alias invoice_available? document_available?
  alias invoice_creatable? document_creatable?

  private

  def document_type
    "BookingInvoice"
  end
end
