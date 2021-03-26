# frozen_string_literal: true

module Pricings
  module ResourceSku
    class GetStrategyOptions
      include Interactor

      CONTEXT_PARAMS = %i[
        strategy_class
        pricings
        resource_sku
        adults
        kids
        babies
        starts_on
        ends_on
        errors
      ].freeze

      STRATEGY_OPTIONS = {
        Pricings::Strategies::Fixed => :fixed_strategy_options,
        Pricings::Strategies::PerPerson => :per_person_strategy_options,
        Pricings::Strategies::PerPersonAndNight => :per_person_and_night_strategy_options,
        Pricings::Strategies::ConsecutiveDays => :consecutive_days_options
      }.freeze

      delegate(*CONTEXT_PARAMS, to: :context)

      before do
        context.errors ||= []
      end

      def call
        if options_method_name.blank?
          errors << "No strategy class that meets these conditions!"

          context.fail!
        end

        context.strategy_options = strategy_options
      end

      private

      def options_method_name
        @options_method_name ||= STRATEGY_OPTIONS[strategy_class]
      end

      def strategy_options
        @strategy_options ||= send(options_method_name)
      end

      def fixed_strategy_options
        default_strategy_options.merge(pricings: pricings.fixed)
      end

      def per_person_strategy_options
        default_strategy_options.merge(pricings: pricings.per_person)
      end

      def per_person_and_night_strategy_options
        strategy_options_with_dates.merge(pricings: pricings.per_person_and_night)
      end

      def consecutive_days_options
        strategy_options_with_dates.merge(resource_sku: resource_sku, pricings: pricings.consecutive_days)
      end

      def default_strategy_options
        @default_strategy_options ||=
          {
            adults: adults || 0,
            babies: babies || 0,
            kids: kids || 0
          }
      end

      def strategy_options_with_dates
        default_strategy_options.merge(starts_on: starts_on, ends_on: ends_on)
      end
    end
  end
end
