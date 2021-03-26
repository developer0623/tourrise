# frozen_string_literal: true

class BookingFlightRequest < ApplicationRecord
  belongs_to :booking

  validates :starts_on, :ends_on, :departure_airport, presence: true
  validates :destination_airport, :departure_airport, airport_code: true
  validates :starts_on, at_future: true

  validates_with EndsOnAfterStartsOnValidator

  def starts_on_in_future
    return unless starts_on.present?

    errors.add(:starts_on, :must_be_in_future) if starts_on < Time.zone.now
  end
end
