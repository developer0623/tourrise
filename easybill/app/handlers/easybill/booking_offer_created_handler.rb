# frozen_string_literal: true

module Easybill
  class BookingOfferCreatedHandler
    def self.handle(booking_offer_data)
      CreateOfferJob.perform_later(booking_offer_data)
    end
  end
end
