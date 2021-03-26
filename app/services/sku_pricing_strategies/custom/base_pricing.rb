# frozen_string_literal: true

module SkuPricingStrategies
  module Custom
    class BasePricing
      attr_reader :pricings, :count, :starts_on, :ends_on

      def initialize(options = {})
        @pricings = options[:pricings]
        @count = options[:count] || 1
        @ends_on = options[:ends_on]
        @starts_on = options[:starts_on]
      end

      def collect!
        return [] if count.zero?

        range.blank? ? collect_by_time : [[1, range]]
      end

      private

      def pricing_rule
        @pricing_rule ||= select_pricing_rule
      end

      def select_pricing_rule
        pricings.first
      end

      def range
        @range ||= select_range
      end

      def select_range
        options = { ranges: pricing_rule.consecutive_days_ranges, days: days }

        result = Pricings::ConsecutiveDays::SelectRange.call(options)

        return result.range if result.success?

        # TODO: Add error handling
      end

      def days
        (starts_on.to_date..ends_on.to_date).count
      end

      def collect_by_time
        raise "Not implemented!"
      end
    end
  end
end
