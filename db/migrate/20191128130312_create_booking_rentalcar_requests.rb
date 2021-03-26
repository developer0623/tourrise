class CreateBookingRentalcarRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_rentalcar_requests do |t|
      t.belongs_to :booking

      t.date :starts_on
      t.date :ends_on

      t.string :rentalcar_class

      t.timestamps
    end
  end
end
