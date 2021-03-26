class CreateEasybillCustomerSync < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_customer_syncs do |t|
      t.datetime :last_sync_at, null: false
    end
  end
end
