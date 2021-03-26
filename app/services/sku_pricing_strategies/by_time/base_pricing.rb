# frozen_string_literal: true

module SkuPricingStrategies
  module ByTime
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

        nights.each_with_object([]) do |date, pricings|
          price_for_date = pricing_for_date(date)

          pricings << [count, price_for_date] if price_for_date.present?
        end
      end

      def nights
        (starts_on..ends_on - 1.day)
      end

      def pricing_for_date(date)
        pricings.all_groups.for_date(date).first || pricings.all_groups.first
      end
    end
  end
end
