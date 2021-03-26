# frozen_string_literal: true

module Frontoffice
  class BookingInsuranceRequestFormDecorator < BookingFormDecorator
    def redirect_to
      h.edit_frontoffice_booking_path(
        booking_id,
        step: current_step.next_step_handle
      )
    end

    def insurances
      object.insurances.map do |package|
        Frontoffice::ResourceDecorator.decorate(package)
      end
    end

    def current_step_handle
      :insurance_request
    end
  end
end
