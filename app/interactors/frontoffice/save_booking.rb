# frozen_string_literal: true

module Frontoffice
  class SaveBooking
    include Interactor

    def call
      context.fail!(message: context.booking.errors) unless context.booking.save
    end
  end
end
