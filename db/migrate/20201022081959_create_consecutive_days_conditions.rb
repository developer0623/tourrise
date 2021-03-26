class CreateConsecutiveDaysConditions < ActiveRecord::Migration[6.0]
  def change
    create_table :consecutive_days_conditions do |t|
      t.references :resource_sku
      t.monetize :price, default: 0
      t.integer :upper_operator, limit: 1
      t.integer :lower_operator, limit: 1
      t.integer :upper_limit, limit: 2
      t.integer :lower_limit, limit: 2

      t.timestamps
    end
  end
end
