# frozen_string_literal: true

module Frontoffice
  class RejectBookingOffer
    include Interactor

    delegate :booking_offer, :scrambled_id, to: :context
    delegate :booking, to: :booking_offer

    before do
      context.booking_offer = BookingOffer.find_by(scrambled_id: scrambled_id)
    end

    after do
      BookingOfferMailer.with(booking_offer: booking_offer).offer_state_changed_mail.deliver_later
    end

    def call
      context.fail!(message: :not_found) unless booking_offer.present?

      context.fail!(message: I18n.t("booking_form.booking_offer.offer_rejected_error")) unless booking_offer.update(rejected_at: Time.zone.now)

      Bookings::ChangeSecondaryState.call(booking: booking, secondary_state: :offer_rejected)
    end
  end
end
