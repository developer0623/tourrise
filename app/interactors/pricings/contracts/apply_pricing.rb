# frozen_string_literal: true

module Pricings
  module Contracts
    class ApplyPricing < Dry::Validation::Contract
      params do
        required(:strategy_class)

        required(:strategy_options).hash do
          required(:pricings)
        end
      end

      rule(:strategy_class) do
        if Pricings::STRATEGIES.exclude?(value)
          message = "Strategy class is not in a list of strategies!"

          key.failure(message)
        end
      end

      rule(strategy_options: :pricings) do
        ancestors = value.class.ancestors

        if ancestors.exclude?(ActiveRecord::Relation)
          message = ":pricings Can only be type of ActiveRecord Relation!"

          key.failure(message)
        end
      end
    end
  end
end
