# frozen_string_literal: true

module Frontoffice
  class LoadBookingOffer < LoadBookingDocument
    before :load_booking

    def call
      context.booking_offer = context.booking.booking_offers.find_by(scrambled_id: context.offer_scrambled_id)

      context.fail!(message: :not_found) unless context.booking_offer.present?
    end
  end
end
