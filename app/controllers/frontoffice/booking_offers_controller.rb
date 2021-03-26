# frozen_string_literal: true

module Frontoffice
  class BookingOffersController < FrontofficeController
    decorates_assigned :booking_offer, with: Frontoffice::BookingOfferDecorator

    def show
      load_booking_offer
    end

    def accept
      context = Frontoffice::AcceptBookingOffer.call(scrambled_id: params[:scrambled_id], booking_params: booking_params)

      flash[:error] = context.message unless context.success?

      redirect_to frontoffice_booking_offer_path(booking_scrambled_id: params[:booking_scrambled_id], scrambled_id: params[:scrambled_id])
    end

    def reject
      context = Frontoffice::RejectBookingOffer.call(scrambled_id: params[:scrambled_id])

      flash[:error] = context.message unless context.success?

      redirect_to frontoffice_booking_offer_path(booking_scrambled_id: params[:booking_scrambled_id], scrambled_id: params[:scrambled_id])
    end

    private

    def load_booking_offer
      context = LoadBookingOffer.call(
        booking_scrambled_id: params[:booking_scrambled_id],
        offer_scrambled_id: params[:scrambled_id]
      )
      if context.success?
        @booking_offer = context.booking_offer
      else
        render_not_found
      end
    end

    def booking_params
      params.require(:booking).permit(%i[terms_of_service_accepted privacy_policy_accepted])
    end
  end
end
