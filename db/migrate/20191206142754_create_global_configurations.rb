class CreateGlobalConfigurations < ActiveRecord::Migration[6.0]
  def change
    create_table :global_configurations do |t|
      t.string :company_name

      t.timestamps
    end
  end
end
