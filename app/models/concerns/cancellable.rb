# frozen_string_literal: true

module Cancellable
  extend ActiveSupport::Concern

  included do
    has_one :cancellation, as: :cancellable

    scope :not_cancelled, -> { left_joins(:cancellation).where(cancellations: { id: nil }) }

    def canceled?
      cancellation.present?
    end
  end
end
