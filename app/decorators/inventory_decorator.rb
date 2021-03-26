# frozen_string_literal: true

class InventoryDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  decorates_association :availabilities
  decorates_association :resource_skus
  decorates_association :booking_resource_skus, scope: :without_drafts

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << [
        "State",
        "Ressourcenname",
        "Ressource SKU name",
        "Ressource SKU handle",
        "Buchungsnummer",
        "Beginn",
        "Ende",
        "Berechnungsgrundlage",
        "Anzahl",
        "Preis",
        "Gesamtpreis",
        "Person(en)",
        "Remarks"
      ]

      object.resource_skus.each do |resource_sku|
        resource_sku.booking_resource_skus.with_aasm_state(%i[requested in_progress booked]).each do |booking_resource_sku|
          csv << [
            booking_resource_sku.aasm_state,
            booking_resource_sku.resource_snapshot["name"],
            booking_resource_sku.resource_sku_snapshot["name"],
            booking_resource_sku.resource_sku_snapshot["handle"],
            booking_resource_sku.booking_id,
            booking_resource_sku.booking.starts_on.iso8601,
            booking_resource_sku.booking.ends_on.iso8601,
            booking_resource_sku.calculation_type,
            booking_resource_sku.quantity,
            booking_resource_sku.price,
            booking_resource_sku.total_price,
            booking_resource_sku.participants.map { |participant| "#{participant.first_name} #{participant.last_name} #{participant.birthdate}" }.join(", "),
            booking_resource_sku.remarks
          ]
        end
      end
    end
  end

  def with_bookings_on(date)
    availabilities.any? do |availability|
      availability.availability_reducing_booking_resource_skus.in_date_range(date, date).any?
    end
  end
end
