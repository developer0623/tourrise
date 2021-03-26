class CreateEasybillEmployees < ActiveRecord::Migration[6.0]
  def change
    create_table :easybill_employees do |t|
      t.belongs_to :user

      t.text :api_key
    end
  end
end
