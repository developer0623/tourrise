# frozen_string_literal: true

module Frontoffice
  class AcceptBookingOffer
    include Interactor

    delegate :booking_offer, :scrambled_id, :booking_params, to: :context
    delegate :booking, to: :booking_offer

    before do
      context.booking_offer = BookingOffer.find_by(scrambled_id: scrambled_id)
    end

    after do
      BookingOfferMailer.with(booking_offer: booking_offer).offer_state_changed_mail.deliver_later
    end

    def call
      context.fail!(message: :not_found) unless booking_offer.present?

      booking.update(booking_params)

      context.fail!(message: I18n.t("booking_form.booking_offer.booking_tos_and_pp_not_accepted")) unless booking_tos_and_pp_accepted?
      context.fail!(message: I18n.t("booking_form.booking_offer.offer_accepted_error")) unless booking_offer.update(accepted_at: Time.zone.now)

      Bookings::ChangeSecondaryState.call(booking: booking, secondary_state: :invoice_missing)
    end

    private

    def booking_tos_and_pp_accepted?
      booking.terms_of_service_accepted? && booking.privacy_policy_accepted?
    end
  end
end
