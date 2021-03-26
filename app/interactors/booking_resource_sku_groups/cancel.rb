# frozen_string_literal: true

module BookingResourceSkuGroups
  class Cancel
    include Interactor::Organizer

    organize Cancellations::CreateForPosition
  end
end
