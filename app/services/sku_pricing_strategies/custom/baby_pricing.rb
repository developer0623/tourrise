# frozen_string_literal: true

module SkuPricingStrategies
  module Custom
    class BabyPricing < BasePricing
      private

      def select_pricing_rule
        pricings.babies.first || super
      end

      def collect_by_time
        SkuPricingStrategies::ByTime::BabyPricing.new(by_time_strategy_options).collect!
      end

      def by_time_strategy_options
        { pricings: pricings, count: count, ends_on: ends_on, starts_on: starts_on }
      end
    end
  end
end
