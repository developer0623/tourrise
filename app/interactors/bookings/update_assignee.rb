# frozen_string_literal: true

module Bookings
  class UpdateAssignee
    include Interactor

    def call
      context.booking.assignee = context.user

      context.fail!(message: context.booking.errors.full_messages) unless context.booking.save
    end
  end
end
