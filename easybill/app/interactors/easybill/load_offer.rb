# frozen_string_literal: true

module Easybill
  class LoadOffer
    include Interactor

    def call
      context.offer = Offer.find_by_booking_offer_id(context.booking_offer_id)

      context.fail!(message: "No easybill offer found for #{context.booking_offer_id}") unless context.offer.present?
    end
  end
end
