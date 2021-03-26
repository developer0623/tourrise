module Seeds
  module ResourceTypes
    def seed!
      pp "Seeding Resources Types"
      ::ResourceTypes::SetupResourceTypeBasic.call!
      ::ResourceTypes::SetupResourceTypeAccommodation.call
      ::ResourceTypes::SetupResourceTypeFlight.call
      ::ResourceTypes::SetupResourceTypeTransfer.call
      ::ResourceTypes::SetupResourceTypeTrainingPackage.call
      ::ResourceTypes::SetupResourceTypeIslandHopping.call
      ::ResourceTypes::SetupResourceTypeRentalcar.call
      ::ResourceTypes::SetupResourceTypeRentalbike.call
      ::ResourceTypes::SetupResourceTypeDiscount.call
      ::ResourceTypes::SetupResourceTypeInsurance.call
    end
    module_function :seed!
  end
end
