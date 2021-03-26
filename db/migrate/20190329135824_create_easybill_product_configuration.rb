class CreateEasybillProductConfiguration < ActiveRecord::Migration[5.2]
  def change
    create_table :easybill_product_configurations do |t|
      t.references :product

      t.string :offer_template
      t.string :invoice_template

      t.timestamps
    end
  end
end
