# frozen_string_literal: true

module BookingCredits
  module RecalculatePrice
    class ForAll
      include Interactor::Organizer

      organize ForCreated, ForUpdated, ForRemoved
    end
  end
end
