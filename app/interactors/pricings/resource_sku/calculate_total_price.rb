# frozen_string_literal: true

module Pricings
  module ResourceSku
    class CalculateTotalPrice
      include Interactor::Organizer

      before do
        context.price ||= NullPrice.price
        context.applied_pricings = []
        context.adults ||= 0
        context.kids ||= 0
        context.babies ||= 0
        context.errors ||= []
      end

      organize ChoosePricingStrategy, ApplyPricingStrategy
    end
  end
end
