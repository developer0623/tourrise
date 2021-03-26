# frozen_string_literal: true

module Bookings
  class ChangeBookingState
    include Interactor

    before :validate_transition_method
    before :memoize_current_state

    def call
      context.booking.public_send("#{context.transition_method_name}!")
    end

    def rollback
      context.booking.update_column(:aasm_state, context.memoized_state)
    end

    private

    def validate_transition_method
      raise "invalid usage. no transition method defined" unless context.transition_method_name.present?

      return if context.booking.public_send("may_#{context.transition_method_name}?")

      context.fail!(message: "Cannot #{context.transition_method_name} booking. Booking is in state #{context.booking.aasm_state}.")
    end

    def memoize_current_state
      context.memoized_state = context.booking.aasm_state
    end
  end
end
