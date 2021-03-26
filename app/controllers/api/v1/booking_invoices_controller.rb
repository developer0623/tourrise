# frozen_string_literal: true

module Api
  module V1
    class BookingInvoicesController < Api::V1Controller
      def index
        context = BookingInvoices::Index::List.call(page: params[:page], limit: params[:limit], filter: filter_params)

        if context.success?
          render index_context_as_json(context)
        else
          render json: { error: context.message }, status: :bad_request
        end
      end

      private

      def filter_params
        {
          created_at: params[:created_at]
        }
      end

      def index_context_as_json(context)
        {
          jsonapi: context.booking_invoices,
          class: {
            Booking: Api::V1::SerializableBooking,
            BookingInvoice: Api::V1::SerializableBookingInvoice,
            AdvanceBookingInvoice: Api::V1::SerializableBookingInvoice,
            ProductSku: Api::V1::SerializableProductSku,
            Customer: Api::V1::SerializableCustomer,
            Payment: Api::V1::SerializablePayment
          },
          meta: {
            total_count: context.booking_invoices.total_count,
            total_pages: context.booking_invoices.total_pages,
            current_page: context.booking_invoices.current_page
          },
          include: [
            :payments,
            booking: %i[customer product_sku]
          ]
        }
      end
    end
  end
end
