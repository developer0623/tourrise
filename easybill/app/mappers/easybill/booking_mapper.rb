# frozen_string_literal: true

module Easybill
  class BookingMapper
    DEFAULT_GRACE_PERIOD = 14
    PAYMENT_DAYS_BEFORE_START = 30.days
    VALID_TYPES = %w[OFFER INVOICE ADVANCE_INVOICE].freeze
    DEFAULT_VAT_OPTION = "sStfr" # enum nStb, nStbUstID, nStbNoneUstID, nStbNoneUstID, revc, IG, AL, sStfr, smallBusiness

    class << self
      def to_easybill_document(booking, document, type:)
        validate_type(type)

        data = default_data(booking, document, type)
        data[:due_in_days] = due_in_days(booking) if booking.starts_on.present?
        data[:service_date] = service_date(booking) if needs_service_date?(booking, type)
        data[:text] = to_easybill_text(booking, document, type)

        data
      end

      private

      def default_data(booking, document, type)
        {
          external_id: booking.id,
          customer_id: easybill_customer_id(booking),
          document_date: to_easybill_date(Time.zone.now.to_date),
          title: to_document_title(booking, document),
          type: type,
          items: to_easybill_items(type, booking, document),
          pdf_template: pdf_template(booking, type),
          vat_option: DEFAULT_VAT_OPTION
        }
      end

      def needs_service_date?(booking, type)
        return false unless %w[INVOICE ADVANCE_INVOICE].include?(type)

        booking.starts_on.present?
      end

      def pdf_template(booking, type)
        configuration = ::Easybill::ProductConfiguration.find_by(product_id: booking.product.id)

        if configuration.present?
          configuration.public_send("#{type.downcase}_template")
        else
          ::Easybill::ProductConfiguration.public_send("default_#{type.downcase}_template")
        end
      end

      def validate_type(type)
        raise "invalid type: #{type}. Choose one of #{VALID_TYPES}" unless VALID_TYPES.include?(type)
      end

      def to_easybill_items(type, booking, document)
        return advance_payment_snapshot(document) if type == "ADVANCE_INVOICE"

        (booking_sku_groups_from_snapshot(booking, document) + booking_skus_from_snapshot(booking, document) + booking_credits_from_snapshot(booking, document)).flatten
      end

      def booking_sku_groups_from_snapshot(booking, document)
        document.booking_resource_sku_groups_snapshot.filter_map do |group|
          ::Easybill::BookingResourceSkuGroupMapper.new(booking: booking, booking_resource_sku_group: group, document: document).call
        end.flatten
      end

      def booking_skus_from_snapshot(booking, document)
        document.booking_resource_skus_snapshot.filter_map do |booking_resource_sku_snapshot|
          next if booking_resource_sku_snapshot["internal"]

          ::Easybill::BookingResourceSkuMapper.new(booking: booking, booking_resource_sku: booking_resource_sku_snapshot).call
        end.flatten
      end

      def booking_credits_from_snapshot(booking, document)
        document.booking_credits_snapshot.filter_map do |booking_credit|
          ::Easybill::BookingCreditMapper.new(booking: booking, booking_credit: booking_credit).call
        end.flatten
      end

      def easybill_customer_id(booking)
        customer = ::Easybill::Customer.find_by(customer_id: booking.customer_id)
        raise Errors::CustomerNotSyncedError unless customer.present?

        customer.external_id
      end

      def due_in_days(booking)
        due_in_days = (((booking.starts_on - PAYMENT_DAYS_BEFORE_START)) - Time.zone.now.to_date).to_i

        return due_in_days if due_in_days > DEFAULT_GRACE_PERIOD

        DEFAULT_GRACE_PERIOD
      end

      def service_date(booking)
        service_date = { type: "SERVICE" }

        if booking.with_date_range?
          return service_date.merge!(
            date_from: to_easybill_date(booking.starts_on),
            date_to: to_easybill_date(booking.ends_on)
          )
        end

        service_date.merge!(date: to_easybill_date(booking.starts_on))
      end

      def to_easybill_date(date)
        return unless date

        date.iso8601
      end

      def to_document_title(booking, document)
        title = document.booking_snapshot["title"]

        title += " (#{I18n.l(booking.starts_on)} - #{I18n.l(booking.ends_on)})" if booking.with_date_range?

        title
      end

      def to_easybill_text(booking, document, type)
        ApplicationController.render(partial: "easybill/templates/#{type.downcase}_end", locals: { booking: booking, document: document })
      end

      def advance_payment_snapshot(document)
        [{
          "number" => "-",
          "description" => I18n.t("booking_credits.advance_booking_invoice.title"),
          "quantity" => 1,
          "vat_percent" => 0.0,
          "single_price_net" => document.payments.first.price_cents.to_f
        }]
      end
    end
  end
end
