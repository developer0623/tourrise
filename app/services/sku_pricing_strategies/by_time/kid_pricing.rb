# frozen_string_literal: true

module SkuPricingStrategies
  module ByTime
    class KidPricing < BasePricing
      def pricing_for_date(date)
        pricings.kids.for_date(date).first ||
          pricings.all_groups.for_date(date).first ||
          pricings.kids.first ||
          pricings.all_groups.first
      end
    end
  end
end
