# frozen_string_literal: true

module BookingInvoices
  module Index
    class Load
      include Interactor

      def call
        context.booking_invoices = BookingInvoice.includes(
          :booking,
          :payments
        )
      end
    end
  end
end
