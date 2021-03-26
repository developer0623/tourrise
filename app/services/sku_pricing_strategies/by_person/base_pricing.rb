# frozen_string_literal: true

module SkuPricingStrategies
  module ByPerson
    class BasePricing
      attr_reader :pricings, :count

      def initialize(pricings:, count: 1)
        @pricings = pricings
        @count = count
      end

      def collect!
        [count, pricing] if count.positive? && pricing.present?
      end

      def pricing
        @pricing ||= price_for_all_groups
      end

      private

      def price_for_all_groups
        @price_for_all_groups ||= pricings.all_groups.first
      end
    end
  end
end
