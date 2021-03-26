class AddContactDetailsToGlobalConfiguration < ActiveRecord::Migration[6.0]
  def change
    add_column :global_configurations, :contact_email, :string
    add_column :global_configurations, :contact_phone, :string
  end
end
