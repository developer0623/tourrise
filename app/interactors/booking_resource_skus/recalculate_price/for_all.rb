# frozen_string_literal: true

module BookingResourceSkus
  module RecalculatePrice
    class ForAll
      include Interactor::Organizer

      organize ForCreated, ForUpdated, ForCanceled
    end
  end
end
