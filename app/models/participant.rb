# frozen_string_literal: true

class Participant < Customer
  has_many :booking_participants, foreign_key: "customer_id"
  has_many :bookings, through: :booking_participants

  private

  def contact_customer?
    false
  end
end
