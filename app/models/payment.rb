# frozen_string_literal: true

class Payment < ApplicationRecord
  monetize :price_cents

  belongs_to :booking_invoice
  has_one :booking, through: :booking_invoice

  validates :price, :due_on, presence: true
end
