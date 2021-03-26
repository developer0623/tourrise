# frozen_string_literal: true

class BookingInProgress < Booking
  validates :starts_on,
            :ends_on,
            :scrambled_id,
            :adults,
            :kids,
            :babies,
            :customer,
            :product_sku_id,
            :creator_id, presence: true

  validates :adults, numericality: { greater_than: 0 }
  validates :kids, :babies, numericality: { greater_than_or_equal_to: 0 }

  validate :starts_on_unchanged,
           :ends_on_unchaned,
           :product_sku_id_unchanged, if: -> { final_state? }

  before_validation :update_participant_counters

  private

  def final_state?
    %w[booked canceled closed].include?(aasm_state)
  end
end
