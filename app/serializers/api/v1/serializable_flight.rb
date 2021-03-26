# frozen_string_literal: true

module Api
  module V1
    class SerializableFlight < JSONAPI::Serializable::Resource
      type "flights"

      attributes :id, :airline_code, :flight_number, :arrival_at, :arrival_airport, :departure_at, :departure_airport
    end
  end
end
