# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeFlight < SetupResourceTypeBase
    def call
      setup(:flight)

      add_reservation_number

      save
    end
  end
end
