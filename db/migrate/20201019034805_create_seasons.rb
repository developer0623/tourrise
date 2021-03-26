class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.references :product

      t.string :name
      t.datetime :published_at

      t.timestamps
    end
  end
end
