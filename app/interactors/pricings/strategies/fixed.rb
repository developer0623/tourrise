# frozen_string_literal: true

module Pricings
  module Strategies
    class Fixed < Base
      def pricings_info
        {
          SkuPricingStrategies::ByPerson::AdultPricing => correct_count(adults),
          SkuPricingStrategies::ByPerson::KidPricing => correct_count(kids),
          SkuPricingStrategies::ByPerson::BabyPricing => correct_count(babies)
        }
      end

      private

      def correct_count(count)
        count.to_i.positive? ? 1 : 0
      end
    end
  end
end
