class CreateBookingCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :booking_credits do |t|
      t.references :booking
      t.references :financial_account
      t.references :cost_center

      t.string :name
      t.integer :price_cents, default: 0, null: false
      t.string :price_currency, default: "EUR", null: false

      t.timestamps
    end
  end
end
