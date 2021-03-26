# frozen_string_literal: true

module Bookings
  class CreateBooking
    include Interactor

    def call
      context.booking = Booking.new(create_params)

      generate_title
      generate_participants

      context.booking.request

      context.fail!(message: context.booking.errors.full_messages) unless context.booking.save
    end

    private

    def create_params
      context.params.merge(
        creator_id: context.current_user.id
      )
    end

    def generate_title
      context.booking.title = BookingTitle.from_product_sku(context.booking.product_sku)
    end

    def generate_participants
      context.booking.adults.times do
        context.booking.participants.adults.new(placeholder: true)
      end

      context.booking.kids.times do
        context.booking.participants.kids.new(placeholder: true)
      end

      context.booking.babies.times do
        context.booking.participants.babies.new(placeholder: true)
      end
    end
  end
end
