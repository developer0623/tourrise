# frozen_string_literal: true

module BookingResourceSkuGroups
  class Find
    include Interactor::Organizer

    before do
      context.document_type = "BookingInvoice"
    end

    organize FindCreated, FindUpdated, FindCanceled, CollectForDocument
  end
end
