class AddAllowPartialPaymentToSnapshots < ActiveRecord::Migration[6.0]
  def up
    BookingInvoice.all.each do |invoice|
      next if invoice.booking_resource_sku_groups_snapshot.blank?

      updated_booking_resource_sku_groups_snapshot = invoice.booking_resource_sku_groups_snapshot.map do |group_snapshot|
        next group_snapshot if group_snapshot["allow_partial_payment"].present?

        group_snapshot.merge("allow_partial_payment" => true)
      end

      invoice.update(booking_resource_sku_groups_snapshot: updated_booking_resource_sku_groups_snapshot)
    end

    BookingInvoice.all.each do |invoice|
      next if invoice.booking_resource_skus_snapshot.blank?

      updated_booking_resource_skus_snapshot = invoice.booking_resource_skus_snapshot.map do |sku_snapshot|
        next sku_snapshot if sku_snapshot["allow_partial_payment"].present?

        sku_snapshot.merge("allow_partial_payment" => true)
      end

      invoice.update(booking_resource_skus_snapshot: updated_booking_resource_skus_snapshot)
    end
  end

  def down
    BookingInvoice.all.each do |invoice|
      next if invoice.booking_resource_sku_groups_snapshot.blank?

      updated_booking_resource_sku_groups_snapshot = invoice.booking_resource_sku_groups_snapshot.map do |group_snapshot|
        group_snapshot.delete("allow_partial_payment")
        group_snapshot
      end

      invoice.update(booking_resource_sku_groups_snapshot: updated_booking_resource_sku_groups_snapshot)
    end

    BookingInvoice.all.each do |invoice|
      next if invoice.booking_resource_skus_snapshot.blank?

      updated_booking_resource_skus_snapshot = invoice.booking_resource_skus_snapshot.map do |sku_snapshot|
        sku_snapshot.delete("allow_partial_payment")
        sku_snapshot
      end

      invoice.update(booking_resource_skus_snapshot: updated_booking_resource_skus_snapshot)
    end
  end
end
