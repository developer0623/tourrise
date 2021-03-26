# frozen_string_literal: true

module Api
  module V1
    class BookingsController < Api::V1Controller
      def index
        context = Bookings::ListBookings.call(page: params[:page], limit: params[:limit], filter: filter_params)

        if context.success?
          render index_context_as_json(context)
        else
          render json: { error: context.message }, status: :bad_request
        end
      end

      def show
        booking = Booking.find_by_id(params[:id])

        if booking.present?
          render booking_as_json(booking)
        else
          render json: { error: :not_found }, status: :bad_request
        end
      end

      private

      def filter_params
        {
          status: params[:status],
          product_id: params[:product_id],
          assignee_id: params[:assignee_id],
          created_at: params[:created_at],
          updated_at: params[:updated_at]
        }
      end

      def index_context_as_json(context)
        {
          jsonapi: context.bookings,
          class: {
            Booking: Api::V1::SerializableBooking,
            Participant: Api::V1::SerializableParticipant,
            User: Api::V1::SerializableUser,
            ProductSku: Api::V1::SerializableProductSku,
            BookingOffer: Api::V1::SerializableBookingOffer,
            BookingInvoice: Api::V1::SerializableBookingInvoice
          },
          include: %i[participants assignee creator product_sku booking_offers booking_invoices]
        }
      end

      def booking_as_json(booking)
        {
          jsonapi: booking,
          class: {
            Booking: Api::V1::SerializableBooking,
            Customer: Api::V1::SerializableCustomer,
            Participant: Api::V1::SerializableParticipant,
            User: Api::V1::SerializableUser,
            ProductSku: Api::V1::SerializableProductSku,
            BookingOffer: Api::V1::SerializableBookingOffer,
            BookingInvoice: Api::V1::SerializableBookingInvoice,
            BookingResourceSku: Api::V1::SerializableBookingResourceSku,
            BookingAttributeValue: Api::V1::SerializableBookingAttributeValue,
            Flight: Api::V1::SerializableFlight
          },
          include: %i[
            customer
            participants
            assignee
            creator
            product_sku
            booking_offers
            booking_invoices
            flights
          ] << { booking_resource_skus: %i[participants booking_attribute_values] }
        }
      end
    end
  end
end
