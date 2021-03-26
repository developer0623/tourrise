# frozen_string_literal: true

class BookingOfferMailerPreview < ActionMailer::Preview
  def offer_state_changed_mail
    BookingOfferMailer.with(booking_offer: BookingOffer.last).offer_state_changed_mail
  end
end
