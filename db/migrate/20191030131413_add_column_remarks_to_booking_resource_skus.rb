class AddColumnRemarksToBookingResourceSkus < ActiveRecord::Migration[6.0]
  def change
    add_column :booking_resource_skus, :remarks, :text
  end
end
