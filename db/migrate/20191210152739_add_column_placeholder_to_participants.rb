class AddColumnPlaceholderToParticipants < ActiveRecord::Migration[6.0]
  def change
    add_column :participants, :placeholder, :boolean, default: false
  end
end
