# frozen_string_literal: true

module Easybill
  class BookingResourceSkuGroupMapper
    TAB = Array.new(8, "&nbsp;").join("")

    attr_reader :booking, :booking_resource_sku_group, :document, :result

    def initialize(booking:, booking_resource_sku_group:, document:)
      @booking = booking
      @document = document
      @booking_resource_sku_group = booking_resource_sku_group
    end

    def call
      document_item = to_document_item

      text_items = booking_resource_skus.map do |booking_resource_sku|
        to_easybill_text_item(booking_resource_sku)
      end

      text_items << Easybill::FlightsMapper.new(flights).call if flights.any?

      [
        document_item,
        text_items.flatten.compact || []
      ]
    end

    private

    def to_document_item
      document_item = to_easybill_document_item
      document_item[:booking_account] = to_easybill_booking_account
      document_item[:export_cost_1] = to_easybill_export_cost_1

      document_item
    end

    def to_easybill_document_item
      {
        description: booking_resource_sku_group["name"],
        quantity: 1,
        vat_percent: booking_resource_sku_group["vat"],
        single_price_net: to_easybill_price
      }
    end

    def booking_resource_skus
      @booking_resource_skus ||= select_booking_resource_skus
    end

    def select_booking_resource_skus
      sku_ids = booking_resource_sku_group["booking_resource_sku_ids"]

      document.booking_resource_skus_snapshot.select { |sku| sku["id"].in?(sku_ids) }
    end

    def to_easybill_text_item(booking_resource_sku)
      {
        type: "TEXT",
        description: to_easybill_item_description(booking_resource_sku)
      }
    end

    def to_easybill_item_description(booking_resource_sku)
      resource_sku = booking_resource_sku["resource_sku_snapshot"]
      resource = booking_resource_sku["resource_snapshot"]

      description = "#{TAB}#{TAB}#{TAB}#{TAB}#{resource['name']} - #{resource_sku['name']}"

      description += "<br/>#{TAB}#{TAB}#{TAB}#{TAB}#{humanize_participants(booking_resource_sku)}" if booking_resource_sku["participants"].present?

      description
    end

    def flights
      @flights ||= booking_resource_skus.map { |sku| sku["flights"] }.flatten.compact.uniq
    end

    def to_easybill_price
      booking_resource_sku_group["price_cents"].to_f / (booking_resource_sku_group["vat"].to_f / 100 + 1)
    end

    def to_easybill_booking_account
      return unless booking_resource_sku_group["financial_account"].present?

      financial_account_for_date(booking_resource_sku_group["financial_account"], booking.starts_on)
    end

    def financial_account_for_date(financial_account, starts_on = nil)
      return unless starts_on.present?

      return financial_account["before_service_year"] if starts_on.year > Time.zone.now.year

      financial_account["during_service_year"]
    end

    def to_easybill_export_cost_1
      return unless booking_resource_sku_group["cost_center"].present?

      booking_resource_sku_group["cost_center"]["value"]
    end

    def humanize_participants(booking_resource_sku)
      booking_resource_sku["participants"].map do |participant|
        "#{participant['first_name']} #{participant['last_name']}"
      end.join("<br/>#{TAB}#{TAB}#{TAB}#{TAB}")
    end
  end
end
