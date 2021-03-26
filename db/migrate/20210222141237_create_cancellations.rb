class CreateCancellations < ActiveRecord::Migration[6.0]
  def change
    create_table :cancellations do |t|
      t.references :user
      t.references :cancellable, polymorphic: true
      t.references :cancellation_reason

      t.timestamps
    end
  end
end
