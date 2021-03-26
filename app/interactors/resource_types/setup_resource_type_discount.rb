# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeDiscount < SetupResourceTypeBase
    def call
      setup(:discount)

      save
    end
  end
end
