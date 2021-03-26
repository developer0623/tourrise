# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeIslandHopping < SetupResourceTypeBase
    def call
      setup(:island_hopping)

      add_start_date
      add_end_date

      save
    end
  end
end
