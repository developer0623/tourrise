# frozen_string_literal: true

class BookingFlightRequestDecorator < Draper::Decorator
  delegate_all

  def outward_flight
    "#{I18n.l(starts_on, format: :short)} #{departure_airport} #{destination_airport}"
  end

  def return_flight
    "#{I18n.l(ends_on, format: :short)} #{destination_airport} #{departure_airport}"
  end
end
