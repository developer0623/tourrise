# frozen_string_literal: true

module BookingResourceSkus
  module AddDocumentReferences
    class ForAll
      include Interactor::Organizer

      organize ForCreated, ForUpdated, ForCanceled
    end
  end
end
