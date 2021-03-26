class CreateEasybillCustomers < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_customers do |t|
      t.references :customer

      t.string :external_id, null: false, unique: true

      t.timestamps
    end
  end
end
