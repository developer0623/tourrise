# frozen_string_literal: true

module Frontoffice
  class AccommodationsController < FrontofficeController
    before_action :load_booking

    decorates_assigned :booking_form

    def index
      @booking_form = Frontoffice::BookingAccommodationRequestForm.initialize_from_booking(@booking)

      @accommodations = booking_form.available_accommodations(params[:room]).map do |accommodation, rooms|
        [
          AccommodationDecorator.decorate(accommodation),
          RoomDecorator.decorate_collection(rooms)
        ]
      end
    end

    def select
      context = SelectAccommodation.call(
        booking: @booking,
        resource_sku_id: params[:id],
        room: params[:room]
      )

      if context.success?
        redirect_to next_url(context), success: "Super"
      else
        flash[:error] = context.message

        redirect_to frontoffice_booking_accommodations_path(
          params[:booking_scrambled_id],
          room: params[:room]
        )
      end
    end

    private

    def load_booking
      context = LoadBooking.call(scrambled_id: params[:booking_scrambled_id])

      if context.success?
        @booking = context.booking
      else
        render_not_found
      end
    end

    def next_url(context)
      if context.next_step_handle
        return edit_frontoffice_booking_path(
          params[:booking_scrambled_id],
          step: context.next_step_handle
        )
      end

      frontoffice_booking_accommodations_path(
        params[:booking_scrambled_id],
        room: params[:room].next
      )
    end
  end
end
