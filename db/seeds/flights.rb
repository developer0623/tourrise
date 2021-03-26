module Seeds
  class Flights
    def self.seed!
      pp "Seeding flights"

      Flight.create(
        airline_code: 'UA',
        flight_number: '911',
        departure_at: 4.days.from_now.utc,
        departure_airport: 'FRA',
        arrival_at: 5.days.from_now.utc + 2.hours,
        arrival_airport: 'KOA'
      )
      Flight.create(
        airline_code: 'UA',
        flight_number: '913',
        departure_at: 10.days.from_now.utc,
        departure_airport: 'KOA',
        arrival_at: 11.days.from_now.utc + 6.hours,
        arrival_airport: 'FRA'
      )
    end
  end
end
