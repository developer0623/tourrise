# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeDateRangeWithDailyTimeRange < SetupResourceTypeBase
    include Interactor

    def call
      setup(:date_range_with_daily_time_range)

      add_reservation_number
      add_start_date
      add_end_date
      add_start_time
      add_end_time

      save
    end
  end
end
