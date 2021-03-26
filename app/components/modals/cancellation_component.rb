# frozen_string_literal: true

module Modals
  class CancellationComponent < ViewComponent::Base
    def initialize(item:)
      @item = item
    end
  end
end
