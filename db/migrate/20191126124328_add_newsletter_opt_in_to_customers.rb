class AddNewsletterOptInToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :newsletter, :boolean, default: false
  end
end
