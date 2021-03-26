# frozen_string_literal: true

module Bookings
  class ResetDueDate
    include Interactor

    before :memoize_due_on

    def call
      context.booking.update_attribute(:due_on, nil)
    end

    def rollback
      context.booking.update_column(
        :due_on,
        context.memoized_due_on
      )
    end

    private

    def memoize_due_on
      context.memoized_due_on = context.booking.due_on
    end
  end
end
