# frozen_string_literal: true

module Easybill
  class FlightDecorator < Draper::Decorator
    delegate_all

    def flight_code
      "#{object['airline_code']}#{object['flight_number'].rjust(4, '0')}"
    end

    def departure_info
      return unless object["departure_at"].present?

      "#{h.l(object['departure_at'].to_datetime, format: :numeric)} #{Airport.find_by_iata(object['departure_airport']).name}"
    end

    def destination_info
      return unless object["arrival_at"].present?

      "#{h.l(object['arrival_at'].to_datetime, format: :numeric)} #{Airport.find_by_iata(object['arrival_airport']).name}"
    end
  end
end
