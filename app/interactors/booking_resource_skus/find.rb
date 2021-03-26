# frozen_string_literal: true

module BookingResourceSkus
  class Find
    include Interactor::Organizer

    before do
      context.document_type = "BookingInvoice"
    end

    organize FindCreated, FindUpdated, FindCanceled, CollectForDocument
  end
end
