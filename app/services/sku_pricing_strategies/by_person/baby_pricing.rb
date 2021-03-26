# frozen_string_literal: true

module SkuPricingStrategies
  module ByPerson
    class BabyPricing < BasePricing
      def pricing
        @pricing ||= pricings.babies.first || price_for_all_groups
      end
    end
  end
end
