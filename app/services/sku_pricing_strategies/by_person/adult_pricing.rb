# frozen_string_literal: true

module SkuPricingStrategies
  module ByPerson
    class AdultPricing < BasePricing
      def pricing
        @pricing ||= pricings.adults.first || price_for_all_groups
      end
    end
  end
end
