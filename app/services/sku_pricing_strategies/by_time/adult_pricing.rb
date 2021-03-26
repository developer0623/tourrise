# frozen_string_literal: true

module SkuPricingStrategies
  module ByTime
    class AdultPricing < BasePricing
      def pricing_for_date(date)
        pricings.adults.for_date(date).first ||
          pricings.all_groups.for_date(date).first ||
          pricings.adults.first ||
          pricings.all_groups.first
      end
    end
  end
end
