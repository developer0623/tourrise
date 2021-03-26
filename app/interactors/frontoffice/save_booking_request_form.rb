# frozen_string_literal: true

module Frontoffice
  class SaveBookingRequestForm
    include Interactor

    def call
      context.booking_request_form = ::Frontoffice::BookingRequestForm.new(
        booking_form_params.merge(
          product_sku_id: context.product_sku.id,
          creator_id: FrontofficeUser.id
        )
      )

      context.fail!(message: I18n.t("bookings.create.error_message")) unless context.booking_request_form.save

      context.booking_id = context.booking_request_form.booking.scrambled_id
    end

    private

    def booking_form_params
      context.params.slice(:starts_on, :ends_on, :adults, :kids, :babies)
    end
  end
end
