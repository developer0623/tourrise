# frozen_string_literal: true

module Frontoffice
  class BookingContactFormDecorator < BookingFormDecorator
    def customer
      object.booking.customer
    end

    def build_customer
      object.booking.build_customer
    end

    def current_step_handle
      :contact
    end
  end
end
