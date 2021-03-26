# frozen_string_literal: true

module SkuPricingStrategies
  module ByTime
    class BabyPricing < BasePricing
      def pricing_for_date(date)
        pricings.babies.for_date(date).first ||
          pricings.all_groups.for_date(date).first ||
          pricings.babies.first ||
          pricings.all_groups.first
      end
    end
  end
end
