# frozen_string_literal: true

module Pricings
  module ResourceSku
    class SelectStrategyClass
      include Interactor

      delegate :resource_sku, :errors, to: :context

      before do
        context.errors ||= []
      end

      def call
        validate_params

        context.strategy_class = select_strategy_class
      end

      private

      def pricings
        context.pricings ||= resource_sku.resource_sku_pricings
      end

      def select_strategy_class
        case
        when pricings.fixed.any?
          Pricings::Strategies::Fixed
        when pricings.per_person.any?
          Pricings::Strategies::PerPerson
        when pricings.consecutive_days.any?
          Pricings::Strategies::ConsecutiveDays
        when pricings.per_person_and_night.any?
          Pricings::Strategies::PerPersonAndNight
        else
          context.errors << "No strategy class that meets these conditions!"

          context.fail!
        end
      end

      def validate_params
        return if contract.success?

        error_messages = contract.errors.messages.map(&:text)

        errors.concat(error_messages)

        context.fail!
      end

      def contract
        @contract ||= Pricings::Contracts::SelectStrategy.new.call(contract_params)
      end

      def contract_params
        { resource_sku: resource_sku }
      end
    end
  end
end
