# frozen_string_literal: true

module Easybill
  class BookingResourceSkuMapper
    attr_reader :booking, :booking_resource_sku, :result

    def initialize(booking:, booking_resource_sku:)
      @booking = booking
      @booking_resource_sku = booking_resource_sku
    end

    def call
      document_item = to_document_item

      text_items = to_text_items

      @result = [document_item, text_items]
    end

    private

    def to_document_item
      document_item = required_document_item_data

      document_item[:position_id] = to_easybill_position_id if position_exists?
      document_item[:export_cost_1] = to_easybill_export_cost_1 if cost_center_exists?
      document_item[:booking_account] = to_easybill_booking_account if financial_account_exists?

      document_item
    end

    def required_document_item_data
      {
        number: booking_resource_sku["resource_sku_snapshot"]["handle"],
        description: to_easybill_item_description,
        quantity: booking_resource_sku["quantity"],
        vat_percent: booking_resource_sku["resource_sku_snapshot"]["vat"],
        single_price_net: to_easybill_price
      }
    end

    def to_text_items
      text_items = []

      text_items << Easybill::FlightsMapper.new(booking_resource_sku["flights"]).call if booking_resource_sku["flights"].present?

      text_items.flatten.compact || []
    end

    def to_easybill_item_description
      resource_sku = booking_resource_sku["resource_sku_snapshot"]
      resource = booking_resource_sku["resource_snapshot"]

      description = "#{resource['name']} - #{resource_sku['name']}"

      description += humanize_time_information if booking_handles.present?

      description += "<br/>#{humanize_participants}" if booking_resource_sku["participants"].present?

      description
    end

    def humanize_participants
      booking_resource_sku["participants"].map do |participant|
        "#{participant['first_name']} #{participant['last_name']}"
      end.join("<br/>")
    end

    def humanize_time_information
      return "<br/>#{humanize_time_range} (#{humanize_date_range})"     if with_date_and_time_range?
      return "<br/>#{humanize_date_range}"                              if with_date_range?
      return "<br/>#{humanize_time_range}"                              if with_time_range?

      ""
    end

    def with_date_and_time_range?
      with_date_range? && with_time_range?
    end

    def with_date_range?
      booking_handles.include?("starts_on") && booking_handles.include?("ends_on")
    end

    def booking_handles
      return unless booking_resource_sku["booking_attribute_values"].present?

      booking_resource_sku["booking_attribute_values"].map { |av| av["handle"] }
    end

    def with_time_range?
      time_handles = booking_handles.select { |av| av.in?(%w[start_time end_time]) }

      time_handles.uniq.count == 2
    end

    def humanize_date_range
      return unless booking_resource_sku["starts_on"].present? && booking_resource_sku["ends_on"].present?

      [
        I18n.l(booking_resource_sku["starts_on"].to_date, format: :long),
        I18n.l(booking_resource_sku["ends_on"].to_date, format: :long)
      ].join(" - ")
    end

    def start_time
      return unless with_time_range?

      starts_times = booking_resource_sku["booking_attribute_values"].select { |av| av["handle"] == "start_time" }

      starts_times.map { |av| av["value"] }
    end

    def end_time
      return unless with_time_range?

      starts_times = booking_resource_sku["booking_attribute_values"].select { |av| av["handle"] == "end_time" }

      starts_times.map { |av| av["value"] }
    end

    def humanize_time_range
      [start_time, end_time].join(" - ")
    end

    def to_easybill_price
      booking_resource_sku["price_cents"].to_f / (booking_resource_sku["resource_sku_snapshot"]["vat"].to_f / 100 + 1)
    end

    def to_easybill_position_id
      ::Easybill::Position.find_by!(resource_sku_id: booking_resource_sku["resource_sku_snapshot"]["id"]).external_id
    end

    def to_easybill_booking_account
      from_hash = booking_resource_sku["financial_account"]

      return financial_account_for_date(booking_resource_sku["financial_account"], booking.starts_on) if from_hash

      booking.product_sku.financial_account.for_date(starts_on: booking.starts_on)
    end

    def financial_account_for_date(financial_account, starts_on = nil)
      return unless starts_on.present?

      return financial_account["before_service_year"] if starts_on.year > Time.zone.now.year

      financial_account["during_service_year"]
    end

    def financial_account_exists?
      booking_resource_sku["financial_account"] || booking&.product_sku&.financial_account.present?
    end

    def cost_center_exists?
      booking_resource_sku["cost_center"] || booking&.product_sku&.cost_center.present?
    end

    def to_easybill_export_cost_1
      from_hash = booking_resource_sku["cost_center"]

      return from_hash["value"] if from_hash

      booking.product_sku.cost_center.value
    end

    def position_exists?
      ::Easybill::Position.find_by(resource_sku_id: booking_resource_sku["resource_sku_snapshot"]["id"]).present?
    end
  end
end
