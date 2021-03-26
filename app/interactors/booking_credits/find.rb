# frozen_string_literal: true

module BookingCredits
  class Find
    include Interactor::Organizer

    before do
      context.document_type = "BookingInvoice"
    end

    organize FindCreated, FindUpdated, FindRemoved, CollectForDocument
  end
end
