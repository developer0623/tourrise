class DropParticipantTypesTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :participant_types do |t|
      t.string :name, null: false
      t.string :handle, null: false

      t.timestamps
    end
  end
end
