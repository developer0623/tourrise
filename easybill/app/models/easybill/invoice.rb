# frozen_string_literal: true

module Easybill
  class Invoice < ApplicationRecord
    belongs_to :booking_invoice

    has_one_attached :pdf

    validates :external_id, presence: true

    scope :active, -> { where(canceled_at: nil) }

    def canceled?
      canceled_at.present?
    end

    def cancel!
      update_attribute(:canceled_at, Time.zone.now)
    end
  end
end
