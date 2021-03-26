# frozen_string_literal: true

module Documents
  module Create
    class BookingOffer
      include Interactor::Organizer

      before do
        context.secondary_state = :offer_sent
      end

      organize Initialize::BookingOffer, Save::BookingOffer, Bookings::ChangeSecondaryState
    end
  end
end
