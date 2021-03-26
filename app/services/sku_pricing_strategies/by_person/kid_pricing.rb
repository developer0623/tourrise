# frozen_string_literal: true

module SkuPricingStrategies
  module ByPerson
    class KidPricing < BasePricing
      def pricing
        @pricing ||= pricings.kids.first || price_for_all_groups
      end
    end
  end
end
