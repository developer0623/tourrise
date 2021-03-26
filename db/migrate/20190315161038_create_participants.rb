class CreateParticipants < ActiveRecord::Migration[5.2]
  def up
    create_table :participants do |t|
      t.references :booking, index: true
      t.references :customer, index: true

      t.string :first_name
      t.string :last_name
      t.date :birthdate
    end

    drop_table :booking_participants
  end

  def down
    create_table :booking_participants do |t|
      t.references :participant
      t.references :booking
    end

    add_index :booking_participants, %i[participant_id booking_id], name: 'index_booking_participants_on_participant_id_and_booking_id', unique: true

    drop_table :participants
  end
end
