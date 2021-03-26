module Seeds
  class Accountings
    def self.seed!
      pp "Seeding accountings"

      FinancialAccount.create(name: "EU", before_service_year: "3281", during_service_year: "4138")
      FinancialAccount.create(name: "DL", before_service_year: "3280", during_service_year: "4139")

      CostCenter.create(name: "HI", value: "11")
      CostCenter.create(name: "AT", value: "1")
      CostCenter.create(name: "Mallorca", value: "13")
      CostCenter.create(name: "Fuerte", value: "19")
    end
  end
end
