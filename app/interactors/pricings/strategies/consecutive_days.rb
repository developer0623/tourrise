# frozen_string_literal: true

module Pricings
  module Strategies
    class ConsecutiveDays < Base
      delegate :starts_on, :ends_on, :pricings, :resource_sku, to: :context

      before { context.errors ||= [] }

      def call
        validate_params

        super
      end

      private

      def pricings_info
        {
          SkuPricingStrategies::Custom::AdultPricing => adults || 0,
          SkuPricingStrategies::Custom::KidPricing => kids || 0,
          SkuPricingStrategies::Custom::BabyPricing => babies || 0
        }
      end

      def raw_applied_pricings
        pricings_info.each_with_object([]) do |(pricing_type, count), pricings_array|
          service_params = {
            count: count,
            pricings: pricings,
            resource_sku: resource_sku,
            starts_on: starts_on,
            ends_on: ends_on
          }

          service_result = pricing_type.new(service_params).collect!

          pricings_array << service_result
        end
      end

      def apply_pricings
        super.flatten(1)
      end

      def validate_params
        return if contract.success?

        error_messages = contract.errors.messages.map(&:text)

        context.errors.concat(error_messages)

        context.fail!
      end

      def contract
        @contract ||= Pricings::Contracts::ConsecutiveDays.new.call(contract_params)
      end

      def contract_params
        { starts_on: starts_on, ends_on: ends_on, pricings: pricings }
      end
    end
  end
end
