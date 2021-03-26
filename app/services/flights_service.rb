# frozen_string_literal: true

class FlightsService
  SEPARATOR = Arel::Nodes.build_quoted(" ")

  class << self
    def search(flights, search_term)
      return flights unless search_term.present?

      concat = Arel::Nodes::NamedFunction.new("concat", [flights_table[:airline_code], SEPARATOR, flights_table[:flight_number]])

      flights.where(concat.matches("%#{search_term}%"))
    end

    def filter(flights, min_departure_at: nil, booking_id: nil)
      flights = filter_by_min_departure_at(flights, min_departure_at)

      filter_by_booking_id(flights, booking_id)
    end

    private

    def flights_table
      @flights_table ||= Flight.arel_table
    end

    def filter_by_min_departure_at(flights, min_departure_at)
      return flights if min_departure_at.nil?

      flights.where(flights_table[:departure_at].gteq(min_departure_at))
    end

    def filter_by_booking_id(flights, booking_id)
      return flights if booking_id.nil?

      flights.joins(booking_resource_sku_flights: :booking_resource_sku).where(booking_resource_skus: { booking_id: booking_id })
    end
  end
end
