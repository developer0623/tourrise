# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeAccommodation < SetupResourceTypeBase
    def call
      setup(:accommodation)

      add_reservation_number
      add_start_date
      add_end_date

      save
    end
  end
end
