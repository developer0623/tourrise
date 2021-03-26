class CreateCancellationReasons < ActiveRecord::Migration[6.0]
  def change
    create_table :cancellation_reasons do |t|
      t.string :handle, null: false
      t.string :name, null: false
      t.text :description
      t.datetime :deleted_at, index: true

      t.timestamps
    end
  end
end
