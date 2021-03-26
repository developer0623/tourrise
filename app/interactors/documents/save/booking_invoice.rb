# frozen_string_literal: true

module Documents
  module Save
    class BookingInvoice < Base
      def call
        context.fail!(message: I18n.t("booking_invoices.created_error")) unless booking_service.invoice_creatable?
        context.fail!(message: I18n.t("booking_invoices.new.invalid_price_error")) unless document_sum_validated

        super
      end

      private

      def event_name
        Event::BOOKING_INVOICE_CREATED
      end

      def document_sum_validated
        document.total_price == document.payments.sum(&:price)
      end
    end
  end
end
