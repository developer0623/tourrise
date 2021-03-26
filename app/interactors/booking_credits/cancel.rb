# frozen_string_literal: true

module BookingCredits
  class Cancel
    include Interactor::Organizer

    organize Cancellations::CreateForPosition
  end
end
