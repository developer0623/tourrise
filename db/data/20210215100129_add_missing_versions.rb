class AddMissingVersions < ActiveRecord::Migration[6.0]
  def up
    BookingResourceSku.left_joins(:versions).where(versions: { id: nil }).each do |booking_resource_sku|
      save_with_version(booking_resource_sku)
    end

    BookingResourceSkuGroup.left_joins(:versions).where(versions: { id: nil }).each do |booking_resource_sku_group|
      save_with_version(booking_resource_sku_group)
    end

    BookingResourceSkuGroup.left_joins(:versions).where(versions: { id: nil }).each do |booking_credit|
      save_with_version(booking_credit)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def save_with_version(item)
    item.paper_trail.save_with_version
  end
end
