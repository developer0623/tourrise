# frozen_string_literal: true

class BookingOffersController < ApplicationController
  decorates_assigned :booking_offer

  def show
    @booking_offer = BookingOffer.find(params[:id])
  end

  def create
    context = Documents::Create::BookingOffer.call(booking_id: params[:booking_id])

    if context.success?
      flash[:notice] = [I18n.t("booking_offers.created"), context.message]
    else
      flash[:error] = context.message
    end

    redirect_to booking_path(id: params[:booking_id])
  end

  def publish
    booking_offer = BookingOffer.find(params[:id])
    booking_offer.update_attribute(:scrambled_id, ScrambledId.generate) unless booking_offer.published?

    redirect_to request.referer
  end

  def unpublish
    booking_offer = BookingOffer.find(params[:id])
    booking_offer.update_attribute(:scrambled_id, nil)

    redirect_to request.referer
  end
end
