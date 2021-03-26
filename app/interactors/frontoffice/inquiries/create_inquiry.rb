# frozen_string_literal: true

module Frontoffice
  module Inquiries
    class CreateInquiry
      include Interactor

      def call
        ActiveRecord::Base.transaction do
          create_customer
          create_booking
          update_first_participant
        end
      end

      private

      def create_customer
        customer_context = Customers::CreateCustomer.call(params: customer_params)

        if customer_context.success?
          context.customer = customer_context.customer
          context.params["customer_id"] = customer_context.customer.id
        else
          context.fail!(message: customer_context.message)
        end
      end

      def customer_params
        context.params.slice("first_name", "last_name", "email")
      end

      def create_booking
        booking_context = Bookings::CreateBooking.call(params: booking_params, current_user: context.current_user)

        if booking_context.success?
          context.booking = booking_context.booking
        else
          context.fail!(message: booking_context.message)
        end
      end

      def booking_params
        context.params.slice(
          "product_sku_id",
          "starts_on",
          "ends_on",
          "wishyouwhat",
          "adults",
          "kids",
          "babies"
        ).merge(
          "customer_id" => context.customer.id
        )
      end

      def update_first_participant
        participant = context.booking.participants.first
        participant.update(context.customer.attributes.except("id"))
      end
    end
  end
end
