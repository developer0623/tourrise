# frozen_string_literal: true

module BookingCredits
  class CollectForDocument
    include Interactor

    delegate :created_booking_credits, :updated_booking_credits, :removed_booking_credits, to: :context

    def call
      context.booking_credits = booking_credits
    end

    private

    def booking_credits
      created_booking_credits + updated_booking_credits + removed_booking_credits
    end
  end
end
