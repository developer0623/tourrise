class AddParticipantTypeToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :participant_type, :integer, default: 0, null: false
  end
end
