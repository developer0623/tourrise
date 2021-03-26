# frozen_string_literal: true

module Documents
  module AddDocumentReferences
    class ForOffer
      include Interactor::Organizer

      organize BookingResourceSkus::AddDocumentReferences::ForAll,
               BookingResourceSkuGroups::AddDocumentReferences::ForAll,
               BookingCredits::AddDocumentReferences::ForAll
    end
  end
end
