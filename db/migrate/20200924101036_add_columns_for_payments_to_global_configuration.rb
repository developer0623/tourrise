class AddColumnsForPaymentsToGlobalConfiguration < ActiveRecord::Migration[6.0]
  def change
    add_column :global_configurations, :partial_payment_percentage, :decimal, precision: 5, scale: 2, default: 20.00
    add_column :global_configurations, :term_of_final_payment, :integer, default: 30
    add_column :global_configurations, :term_of_first_payment, :integer, default: 10
  end
end
