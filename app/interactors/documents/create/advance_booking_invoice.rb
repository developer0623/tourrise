# frozen_string_literal: true

module Documents
  module Create
    class AdvanceBookingInvoice
      include Interactor

      delegate :advance_booking_invoice, to: :context

      before do
        Bookings::LoadBooking.call(context) if context.booking.blank?
        initialize_advance_booking_invoice
      end

      after do
        create_booking_credits
        PublishEventJob.perform_later(Event::BOOKING_INVOICE_CREATED, advance_booking_invoice)
      end

      def call
        assign_params

        context.fail!(message: I18n.t("booking_invoices.new.invalid_price_error")) unless payment_valid?

        advance_booking_invoice.booking_resource_skus_snapshot = [advance_payment_snapshot]

        context.fail!(message: advance_booking_invoice.errors.full_messages) unless advance_booking_invoice.save
      end

      private

      def initialize_advance_booking_invoice
        context.advance_booking_invoice = ::AdvanceBookingInvoice.new(
          booking: context.booking,
          booking_snapshot: booking_snapshot,
          customer_snapshot: customer_snapshot,
          product_sku_snapshot: product_sku_snapshot,
          booking_credits_snapshot: [],
          booking_resource_sku_groups_snapshot: [],
          booking_resource_skus_snapshot: []
        )
      end

      def assign_params
        params = context.params.slice("payments_attributes", "description")
        advance_booking_invoice.assign_attributes(params)
      end

      def booking_snapshot
        context.booking
      end

      def customer_snapshot
        context.booking.customer
      end

      def product_sku_snapshot
        context.booking.product_sku
      end

      def advance_payment_snapshot
        initialize_booking_credit.serialize_as_booking_resource_sku_snapshot
      end

      def create_booking_credits
        initialize_booking_credit.save
      end

      def initialize_booking_credit
        BookingCredit.new(
          booking: context.booking,
          name: I18n.t("booking_credits.advance_booking_invoice.title"),
          price_cents: advance_booking_invoice.payments.first.price_cents,
          financial_account_id: context.params["booking_credit"]["financial_account_id"],
          cost_center_id: context.params["booking_credit"]["cost_center_id"]
        )
      end

      def payment_valid?
        return false if advance_booking_invoice.payments.first.price.zero?

        true
      end
    end
  end
end
