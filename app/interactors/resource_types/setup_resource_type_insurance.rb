# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeInsurance < SetupResourceTypeBase
    def call
      setup(:insurance)

      save
    end
  end
end
