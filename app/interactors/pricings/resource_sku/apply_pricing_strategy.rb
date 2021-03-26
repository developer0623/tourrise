# frozen_string_literal: true

module Pricings
  module ResourceSku
    class ApplyPricingStrategy
      include Interactor

      delegate :strategy_class, :strategy_options, to: :context

      before do
        context.errors ||= []
      end

      def call
        validate_strategy

        if strategy.success?
          context.applied_pricings = strategy.applied_pricings

          context.price = strategy.price
        else
          context.errors << "Strategy execution failed!"

          context.fail!
        end
      end

      def strategy
        context.strategy ||= strategy_class.call(strategy_options)
      end

      private

      def validate_strategy
        return if contract.success?

        error_messages = contract.errors.messages.map(&:text)

        context.errors.concat(error_messages)

        context.fail!
      end

      def contract
        @contract ||= Pricings::Contracts::ApplyPricing.new.call(contract_params)
      end

      def contract_params
        { strategy_class: strategy_class, strategy_options: strategy_options }
      end
    end
  end
end
