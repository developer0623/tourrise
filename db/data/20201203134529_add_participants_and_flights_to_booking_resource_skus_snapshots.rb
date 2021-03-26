class AddParticipantsAndFlightsToBookingResourceSkusSnapshots < ActiveRecord::Migration[6.0]
  def up
    updates_snapshots_in_invoices
    updates_snapshots_in_offers
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end

  private

  def updates_snapshots_in_invoices
    BookingInvoice.find_each { |booking_invoice| replace_snapshots_in_object(booking_invoice) }
  end

  def updates_snapshots_in_offers
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

    return if booking_offer.booking_resource_skus_snapshot.all? do |booking_resource_sku_snapshot|
      booking_resource_sku_snapshot.keys.include?('participants') &&
        booking_resource_sku_snapshot.keys.include?('flights') &&
        booking_resource_sku_snapshot.keys.include?('booking_attribute_values')
    end

    new_snapshot = booking_offer.booking_resource_skus_snapshot.dup

    new_snapshot.each do |booking_resource_sku_snapshot|
      booking_resource_sku = BookingResourceSku.find_by(id: booking_resource_sku_snapshot['id'])

      update_participants(booking_resource_sku_snapshot, booking_resource_sku)
      update_flights(booking_resource_sku_snapshot, booking_resource_sku)
      update_booking_attribute_values(booking_resource_sku_snapshot, booking_resource_sku)
    end

    attributes_to_update[:booking_resource_skus_snapshot] = new_snapshot
  end

  def replace_booking_resource_sku_groups_snapshot(booking_offer, attributes_to_update)
    return if booking_offer.booking_resource_sku_groups_snapshot.blank?

    return if booking_offer.booking_resource_sku_groups_snapshot.all? do |group_snapshot|
      group_snapshot.keys.include?('vat')
    end

    new_snapshot = booking_offer.booking_resource_sku_groups_snapshot.dup

    new_snapshot.each do |booking_resource_sku_group|
      update_vat(booking_resource_sku_group)
    end

    attributes_to_update[:booking_resource_sku_groups_snapshot] = new_snapshot
  end

  def update_participants(snapshot_unit, booking_resource_sku)
    return if snapshot_unit['participants'].present?

    if booking_resource_sku.present?
      snapshot_unit['participants'] = booking_resource_sku.participants.as_json
    else
      snapshot_unit['participants'] = []
    end
  end

  def update_flights(snapshot_unit, booking_resource_sku)
    return if snapshot_unit['flights'].present?

    if booking_resource_sku.present?
      snapshot_unit['flights'] = booking_resource_sku.flights.as_json
    else
      snapshot_unit['flights'] = []
    end
  end

  def update_booking_attribute_values(snapshot_unit, booking_resource_sku)
    return if snapshot_unit['booking_attribute_values'].present?

    if booking_resource_sku.present?
      snapshot_unit['booking_attribute_values'] = booking_resource_sku.booking_attribute_values.as_json
    else
      snapshot_unit['booking_attribute_values'] = []
    end
  end

  def update_vat(snapshot_unit)
    return if snapshot_unit['vat'].present?

    snapshot_unit['vat'] = BookingResourceSkuGroup.find_by(id: snapshot_unit['id'])&.vat&.to_i
  end
end
