# frozen_string_literal: true

module Easybill
  class BookingCreditMapper
    attr_reader :booking, :booking_credit, :result

    def initialize(booking:, booking_credit:)
      @booking = booking
      @booking_credit = booking_credit
    end

    def call
      document_item = to_document_item

      @result = [document_item]
    end

    private

    def to_document_item
      document_item = required_document_item_data

      document_item[:booking_account] = to_easybill_booking_account
      document_item[:export_cost_1] = to_easybill_export_cost_1

      document_item
    end

    def required_document_item_data
      {
        number: "-",
        description: to_easybill_item_description,
        quantity: 1,
        vat_percent: 0.0,
        single_price_net: -booking_credit["price_cents"].to_f
      }
    end

    def to_easybill_item_description
      "#{booking_credit['name']} - #{I18n.l(booking_credit['created_at'].to_date)}"
    end

    def to_easybill_booking_account
      return unless booking_credit["financial_account_id"].present?

      financial_account = FinancialAccount.find(booking_credit["financial_account_id"])

      financial_account.for_date(starts_on: booking.starts_on)
    end

    def to_easybill_export_cost_1
      return unless booking_credit["cost_center_id"].present?

      CostCenter.find(booking_credit["cost_center_id"]).value
    end
  end
end
