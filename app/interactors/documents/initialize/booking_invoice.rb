# frozen_string_literal: true

module Documents
  module Initialize
    class BookingInvoice
      include Interactor::Organizer

      INTERACTORS = [
        Bookings::LoadBooking,
        Initialize::Positions,
        InitializeMainAttributes::BookingInvoice,
        MarkPaymentsForDestruction,
        RecalculatePositionsPrice,
        AddDocumentReferences::ForDocument
      ].freeze

      organize(*INTERACTORS)
    end
  end
end
