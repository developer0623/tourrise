class RemoveResourceOptionsConcept < ActiveRecord::Migration[6.0]
  def change
    drop_table :resource_options
    drop_table :resource_option_values
    drop_table :resource_variants
  end
end
