# frozen_string_literal: true

module Frontoffice
  class SubmitBooking
    include Interactor::Organizer

    after :reset_form_progression

    organize LoadBooking, UpdateBookingAttributes, SaveBooking, SendBookingCreatedMail

    private

    def reset_form_progression
      context.session.delete(:latest_frontoffice_step)
    end
  end
end
