# frozen_string_literal: true

module ResourceTypes
  class SetupResourceTypeTrainingPackage < SetupResourceTypeBase
    def call
      setup(:training_package)

      add_start_date
      add_end_date

      save
    end
  end
end
