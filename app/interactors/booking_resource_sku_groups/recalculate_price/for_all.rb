# frozen_string_literal: true

module BookingResourceSkuGroups
  module RecalculatePrice
    class ForAll
      include Interactor::Organizer

      organize ForCreated, ForUpdated, ForCanceled
    end
  end
end
