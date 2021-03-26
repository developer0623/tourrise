class AddCurrentSeasonToProduct < ActiveRecord::Migration[6.0]
  def change
    add_reference :products, :current_season
  end
end
