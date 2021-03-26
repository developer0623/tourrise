# frozen_string_literal: true

module BookingResourceSkuGroups
  module AddDocumentReferences
    class ForAll
      include Interactor::Organizer

      organize ForCreated, ForUpdated, ForCanceled
    end
  end
end
