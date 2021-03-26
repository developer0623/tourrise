# frozen_string_literal: true

module Api
  class FlightsController < ApiController
    def index
      context = ::Flights::ListFlights.call(filter: filter_params.to_h)

      if context.success?
        render jsonapi: context.flights
      else
        render json: { error: context.message }, status: 400
      end
    end

    def show
      flight = Flight.find(params[:id])

      render jsonapi: flight
    end

    private

    def filter_params
      list_params.merge(
        params.permit(:min_departure_at, :booking_id)
      )
    end
  end
end
