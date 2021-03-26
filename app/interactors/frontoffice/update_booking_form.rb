# frozen_string_literal: true

module Frontoffice
  class UpdateBookingForm
    include Interactor

    before :load_booking_form

    def call
      context.booking_form.assign_attributes(context.params)

      context.fail!(message: context.booking_form.booking.errors.full_messages) unless context.booking_form.save
    end

    private

    def load_booking_form
      LoadBookingForm.call!(context)
    end
  end
end
