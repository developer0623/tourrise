# frozen_string_literal: true

module Pricings
  module Contracts
    class ConsecutiveDays < Dry::Validation::Contract
      params do
        required(:starts_on).value(:date?)
        required(:ends_on).value(:date?)
        required(:pricings)
      end

      rule(:starts_on) do
        if values.data[:ends_on] && value > values.data[:ends_on]
          message = "Starts on should be less than ends on!"

          key.failure(message)
        end
      end

      rule(:pricings) do
        if value.class.ancestors.exclude?(ActiveRecord::Relation)
          message = ":pricings Can only be type of ActiveRecord Relation!"

          key.failure(message)
        end
      end
    end
  end
end
