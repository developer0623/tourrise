# frozen_string_literal: true

class Flight < ApplicationRecord
  self.skip_time_zone_conversion_for_attributes = %i[arrival_at departure_at]

  has_many :booking_resource_sku_flights
  has_many :booking_resource_skus, through: :booking_resource_sku_flights

  has_many :resource_sku_flights
  has_many :resource_skus, through: :resource_sku_flights

  validates :airline_code,
            :flight_number,
            :arrival_at,
            :arrival_airport,
            :departure_at,
            :departure_airport, presence: true

  validates :arrival_airport, :departure_airport, airport_code: true

  scope :order_by_departure_at, -> { order(:departure_at) }

  def display_flight
    "#{airline_code}#{flight_number.rjust(4, '0')} - " \
      "#{I18n.l(departure_at, format: '%Y-%m-%d %H:%M')} " \
      "#{departure_airport} " \
      "#{arrival_airport} " \
      "#{I18n.l(arrival_at, format: '%Y-%m-%d %H:%M')}"
  end
end
