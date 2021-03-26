class AddDateRangeToAvailabilities < ActiveRecord::Migration[5.2]
  def change
    add_column :availabilities, :starts_at, :datetime
    add_column :availabilities, :ends_at, :datetime
  end
end
