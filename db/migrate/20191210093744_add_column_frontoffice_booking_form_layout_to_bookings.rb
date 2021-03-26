class AddColumnFrontofficeBookingFormLayoutToBookings < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :frontoffice_template, :string, null: false, default: 'default'
  end
end
