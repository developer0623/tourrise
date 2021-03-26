# frozen_string_literal: true

module Documents
  module Initialize
    class BookingOffer
      include Interactor::Organizer

      INTERACTORS = [
        Bookings::LoadBooking,
        Initialize::Positions,
        InitializeMainAttributes::BookingOffer,
        RecalculatePositionsPrice,
        AddDocumentReferences::ForDocument
      ].freeze

      organize(*INTERACTORS)
    end
  end
end
