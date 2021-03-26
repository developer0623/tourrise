# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeRentalbike < SetupResourceTypeBase
    def call
      setup(:rentalbike)

      add_start_date
      add_end_date
      add_height

      save
    end
  end
end
