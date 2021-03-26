# frozen_string_literal: true

module Documents
  module Create
    class BookingInvoice
      include Interactor::Organizer

      before do
        context.secondary_state = :invoice_sent
      end

      organize Initialize::BookingInvoice, Save::BookingInvoice, Bookings::ChangeSecondaryState
    end
  end
end
