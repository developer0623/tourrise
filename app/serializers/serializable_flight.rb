# frozen_string_literal: true

class SerializableFlight < JSONAPI::Serializable::Resource
  type "flights"

  attributes :id, :airline_code, :flight_number, :arrival_at, :arrival_airport, :departure_at, :departure_airport

  attribute :display_flight do
    "#{@object.airline_code} #{@object.flight_number}"
  end

  attribute :display_arrival_at do
    I18n.l(@object.arrival_at, format: :long)
  end

  attribute :display_departure_at do
    I18n.l(@object.departure_at, format: :long)
  end

  link :self do
    "#"
  end
end
