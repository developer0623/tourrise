# frozen_string_literal: true

module Frontoffice
  class BookingOfferDecorator < BookingDocumentDecorator
    def accept_link
      h.button_to(
        h.t("booking_form.booking_offer.accept"),
        h.public_send("accept_frontoffice_booking_offer_path", scrambled_id: object.scrambled_id),
        method: "patch",
        class: "Button Button--primary u-floatRight u-marginBottomBase"
      )
    end

    def reject_link
      h.button_to(
        h.t("booking_form.booking_offer.reject"),
        h.public_send("reject_frontoffice_booking_offer_path", scrambled_id: object.scrambled_id),
        method: "patch",
        class: "Button Button--Link u-floatRight u-marginBottomBase u-marginRightSmall"
      )
    end

    def accepted?
      return true if object.accepted_at.present?
    end

    def rejected?
      return true if object.rejected_at.present?
    end

    private

    def easybill_document
      ::Easybill::Offer.find_by(booking_offer: object)
    end
  end
end
