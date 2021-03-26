class CreateConsecutiveDaysRange < ActiveRecord::Migration[6.0]
  def change
    drop_table :consecutive_days_conditions

    create_table :consecutive_days_ranges do |t|
      t.references :resource_sku
      t.monetize :price, default: 0
      t.integer :from, limit: 2
      t.integer :to, limit: 2

      t.timestamps
    end
  end
end
