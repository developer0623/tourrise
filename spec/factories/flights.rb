# frozen_string_literal: true

FactoryBot.define do
  factory :flight do
    airline_code { 'UA' }
    flight_number { '911' }
    departure_at { 4.days.from_now.utc }
    departure_airport { 'FRA' }
    arrival_at { 5.days.from_now.utc + 2.hours }
    arrival_airport { 'KOA' }
  end
end
