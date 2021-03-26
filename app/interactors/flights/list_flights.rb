# frozen_string_literal: true

module Flights
  class ListFlights
    include Interactor

    def call
      context.flights = Flight.all

      filter
      sort
    end

    private

    def filter
      return if context.filter.blank?

      context.flights = FlightsService.search(context.flights, context.filter["q"]) if context.filter["q"].present?
      context.flights = FlightsService.filter(context.flights, min_departure_at: context.filter["min_departure_at"], booking_id: context.filter["booking_id"])
    end

    def sort
      context.flights = context.flights.uniq.sort_by(&:departure_at)
    end
  end
end
