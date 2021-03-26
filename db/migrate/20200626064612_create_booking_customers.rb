class CreateBookingCustomers < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_customers do |t|
      t.belongs_to :booking
      t.belongs_to :customer
      t.timestamps
    end
  end
end
