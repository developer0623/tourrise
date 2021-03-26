class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.references :booking_invoice

      t.monetize :price
      t.date :due_on

      t.timestamps
    end
  end
end
