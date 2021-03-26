# frozen_string_literal: true

module Pricings
  module Contracts
    class SelectStrategy < Dry::Validation::Contract
      params do
        required(:resource_sku)
      end

      rule(:resource_sku) do
        if value.class.ancestors.exclude?(ActiveRecord::Base)
          message = ":resource_sku Can only be type of ActiveRecord!"

          key.failure(message)
        end
      end
    end
  end
end
