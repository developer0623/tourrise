class AddParticipantTypeIndexToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_index :customers, :participant_type
  end
end
