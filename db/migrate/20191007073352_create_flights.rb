class CreateFlights < ActiveRecord::Migration[6.0]
  def change
    create_table :flights do |t|
      t.string :airline_code
      t.string :flight_number

      t.string :aircraft_name

      t.datetime :arrival_at
      t.string :arrival_airport

      t.datetime :departure_at
      t.string :departure_airport

      t.timestamps
    end
  end
end
