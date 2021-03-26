class CreateParticipantTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :participant_types do |t|
      t.string :name, null: false
      t.string :handle, null: false

      t.timestamps
    end
  end
end
