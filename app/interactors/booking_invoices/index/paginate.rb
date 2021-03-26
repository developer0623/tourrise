# frozen_string_literal: true

module BookingInvoices
  module Index
    class Paginate
      include Interactor

      DEFAULT_LIMIT = 25

      def call
        context.booking_invoices = context.booking_invoices.page(context.page).per(context.limit || DEFAULT_LIMIT)
      end
    end
  end
end
