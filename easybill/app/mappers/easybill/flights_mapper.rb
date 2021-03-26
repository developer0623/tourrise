# frozen_string_literal: true

module Easybill
  class FlightsMapper
    include TableHelper

    attr_reader :flights, :result

    def initialize(flights)
      @flights = flights.sort_by { |flight| flight["departure_at"] }
    end

    def call
      return unless flights.any?

      @result = to_easybill_text_items
    end

    def to_easybill_text_items
      description = table do
        flights_thead + flights_tbody
      end

      {
        type: "TEXT",
        description: description
      }
    end

    def flights_thead
      thead do
        tr do
          th(" #{I18n.t('booking_resource_sku_mapper.flight.departure', scope: :easybill)}", width: "45%") +
            th(" #{I18n.t('booking_resource_sku_mapper.flight.destination', scope: :easybill)}", width: "45%") +
            th(" #{I18n.t('booking_resource_sku_mapper.flight.flight_code', scope: :easybill)}", width: "10%")
        end
      end
    end

    def flights_tbody
      tbody do
        flights.map do |flight|
          flight_row(flight)
        end.join&.html_safe
      end
    end

    def flight_row(flight)
      decorated_flight = Easybill::FlightDecorator.new(flight)

      tr do
        td("  #{decorated_flight.departure_info}") +
          td("  #{decorated_flight.destination_info}") +
          td("  #{decorated_flight.flight_code}")
      end
    end
  end
end
