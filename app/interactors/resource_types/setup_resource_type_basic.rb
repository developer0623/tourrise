# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeBasic < SetupResourceTypeBase
    def call
      setup(:basic)

      save
    end
  end
end
