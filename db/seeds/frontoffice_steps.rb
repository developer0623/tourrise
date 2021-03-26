module Seeds
  class FrontofficeSteps
    def self.seed!
      pp "Seeding Frontoffice Steps"
      steps = %w[
        request accommodation_request flight_request rentalbike_request rentalcar_request training_package_request
        island_hopping_request insurance_request contact participants summary
      ]

      steps.each.with_index(1) do |step, index|
        FrontofficeStep.find_or_create_by(handle: step) do |step|
          step.name = step
          step.description = step
          step.position = index
        end
      end
    end
  end
end