# frozen_string_literal: true

module Documents
  class RecalculatePositionsPrice
    include Interactor::Organizer

    organize BookingResourceSkus::RecalculatePrice::ForAll,
             BookingResourceSkuGroups::RecalculatePrice::ForAll,
             BookingCredits::RecalculatePrice::ForAll
  end
end
