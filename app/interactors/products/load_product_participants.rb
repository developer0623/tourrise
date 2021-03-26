# frozen_string_literal: true

module Products
  class LoadProductParticipants
    include Interactor::Organizer

    organize LoadProduct, LoadBookingParticipants
  end
end
