# frozen_string_literal: true

module Frontoffice
  class BookingDocumentDecorator < Draper::Decorator
    delegate_all

    decorates_association :booking

    def product_name
      object.booking_snapshot["title"]
    end

    def number
      return "#" unless easybill_document.present?

      easybill_document.external_number
    end

    def assignee_email
      object.booking.assignee&.email
    end

    def customer_name
      "#{object.booking.customer.first_name} #{object.booking.customer.last_name}"
    end

    def customer_address_line1
      object.booking.customer.address_line_1
    end

    def customer_city
      "#{object.booking.customer.zip} #{object.booking.customer.city}"
    end

    def currency
      booking_resource_skus_snapshots.sample["price_currency"]
    end

    def humanized_sum(raw_sum, sum_currency)
      h.humanized_money_with_symbol(Money.new(raw_sum, sum_currency))
    end

    def unreduced_price
      h.humanized_money_with_symbol(object.unreduced_price)
    end

    def booking_resource_skus_snapshots
      booking_resource_skus_snapshot.map do |snapshot|
        OpenStruct.new(snapshot)
      end
    end

    def available_booking_resource_skus_snapshots
      booking_resource_skus_snapshots.reject(&:internal)
    end

    def grouped_booking_resource_skus_snapshots
      available_booking_resource_skus_snapshots.group_by do |booking_resource_skus_snapshots|
        next unless booking_resource_skus_snapshots.resource_snapshot.present?

        booking_resource_skus_snapshots.resource_snapshot["name"]
      end
    end

    def booking_resource_sku_groups_snapshots
      booking_resource_sku_groups_snapshot.map do |group|
        OpenStruct.new(group)
      end
    end

    def document_positions
      grouped_booking_resource_skus_snapshots.map do |group_resource, booking_resource_sku_snapshots|
        [
          group_resource,
          booking_resource_sku_snapshots.map { |booking_resource_sku_snapshot| DocumentPositionDecorator.decorate(DocumentPosition.new(booking_resource_sku_snapshot)) }
        ]
      end
    end

    def grouped_document_positions
      booking_resource_sku_groups_snapshots.map do |booking_resource_sku_group_snapshot|
        [
          booking_resource_sku_group_snapshot,
          booking_resource_sku_group_snapshot["booking_resource_sku_ids"].map do |booking_resource_sku_id|
            booking_resource_sku_snapshot = booking_resource_skus_snapshots.find { |booking_resource_sku| booking_resource_sku.id.to_i == booking_resource_sku_id.to_i }

            next unless booking_resource_sku_snapshot.present?

            GroupedDocumentPositionDecorator.decorate(GroupedDocumentPosition.new(booking_resource_sku_snapshot))
          end
        ]
      end
    end

    def underscore_class_name
      object.class.name.underscore
    end
  end
end
