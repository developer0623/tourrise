# frozen_string_literal: true

module Pricings
  module ResourceSku
    class ChoosePricingStrategy
      include Interactor::Organizer

      before do
        context.adults ||= 0
        context.kids ||= 0
        context.babies ||= 0
        context.errors ||= []
      end

      organize SelectStrategyClass, GetStrategyOptions
    end
  end
end
