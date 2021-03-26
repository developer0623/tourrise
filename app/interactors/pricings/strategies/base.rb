# frozen_string_literal: true

module Pricings
  module Strategies
    class Base
      include Interactor

      delegate :pricings, :adults, :kids, :babies, :errors, to: :context

      before { context.errors ||= [] }

      def call
        context.applied_pricings = applied_pricings

        context.price = calculate_price
      end

      def pricings_info
        {
          SkuPricingStrategies::ByPerson::AdultPricing => adults || 0,
          SkuPricingStrategies::ByPerson::KidPricing => kids || 0,
          SkuPricingStrategies::ByPerson::BabyPricing => babies || 0
        }
      end

      private

      def calculate_price
        return Money.new(0) if pricings.blank?

        context.applied_pricings.sum { |multiplier, pricing| multiplier * pricing.price }
      end

      def applied_pricings
        @applied_pricings ||= apply_pricings
      end

      def apply_pricings
        raw_applied_pricings.compact
      end

      def raw_applied_pricings
        pricings_info.each_with_object([]) do |(pricing_type, count), pricings_array|
          pricings_array << pricing_type.new(count: count, pricings: pricings).collect!
        end
      end
    end
  end
end
