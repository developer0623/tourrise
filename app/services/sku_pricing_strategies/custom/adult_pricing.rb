# frozen_string_literal: true

module SkuPricingStrategies
  module Custom
    class AdultPricing < BasePricing
      private

      def select_pricing_rule
        pricings.adults.first || super
      end

      def collect_by_time
        SkuPricingStrategies::ByTime::AdultPricing.new(by_time_strategy_options).collect!
      end

      def by_time_strategy_options
        { pricings: pricings, count: count, ends_on: ends_on, starts_on: starts_on }
      end
    end
  end
end
