# frozen_string_literal: true

module Frontoffice
  class UpdateBookingAttributes
    include Interactor

    def call
      context.booking.update(submit_params)
      context.booking.request
    end

    private

    def submit_params
      context.params.slice(
        :terms_of_service_accepted,
        :privacy_policy_accepted,
        :wishyouwhat,
        :customer_attributes
      )
    end
  end
end
