class ReplaceFinAccountAndCostCenterInSnapshots < ActiveRecord::Migration[6.0]
  def up
    replace_snapshots_in_invoices

    replace_snapshots_in_offers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def replace_snapshots_in_invoices
    BookingInvoice.find_each { |booking_invoice| replace_snapshots_in_object(booking_invoice) }
  end

  def replace_snapshots_in_offers
    BookingOffer.find_each { |booking_offer| replace_snapshots_in_object(booking_offer) }
  end

  def replace_snapshots_in_object(object)
    attributes_to_update = {}

    replace_resource_sku_snapshot(object, attributes_to_update)

    replace_booking_resource_sku_groups_snapshot(object, attributes_to_update)

    object.update_attributes(**attributes_to_update) if attributes_to_update.present?
  end

  def replace_resource_sku_snapshot(booking_offer, attributes_to_update)
    return if booking_offer.booking_resource_skus_snapshot.blank?

    new_snapshot = booking_offer.booking_resource_skus_snapshot.dup

    new_snapshot.each do |resource_sku|
      replace_cost_center(resource_sku)

      replace_financial_account(resource_sku)
    end

    attributes_to_update[:booking_resource_skus_snapshot] = new_snapshot
  end

  def replace_booking_resource_sku_groups_snapshot(booking_offer, attributes_to_update)
    return if booking_offer.booking_resource_sku_groups_snapshot.blank?

    new_snapshot = booking_offer.booking_resource_sku_groups_snapshot.dup

    new_snapshot.each do |resource_sku_group|
      replace_cost_center(resource_sku_group)

      replace_financial_account(resource_sku_group)
    end

    attributes_to_update[:booking_resource_sku_groups_snapshot] = new_snapshot
  end

  def replace_cost_center(snapshot_unit)
    return if snapshot_unit['cost_center_id'].blank?

    snapshot_unit['cost_center'] = CostCenter.find(snapshot_unit['cost_center_id']).attributes

    snapshot_unit.delete('cost_center_id')
  end

  def replace_financial_account(snapshot_unit)
    return if snapshot_unit['financial_account_id'].blank?

    snapshot_unit['financial_account'] = FinancialAccount.find(snapshot_unit['financial_account_id']).attributes

    snapshot_unit.delete('financial_account_id')
  end
end
