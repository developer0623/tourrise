# frozen_string_literal: true

module Bookings
  class UpdateBooking
    include Interactor

    before :load_booking

    def call
      context.booking.assign_attributes(update_params)
      check_participant_completeness

      context.fail!(message: context.booking.errors.full_messages) unless context.booking.save
    end

    private

    def update_params
      context.params.slice(
        :customer_id,
        :product_sku_id,
        :due_on,
        :ends_on,
        :starts_on,
        :assignee_id,
        :secondary_state,
        :season_id,
        :participants_attributes,
        :title,
        :tag_ids
      )
    end

    def load_booking
      context.booking = Booking.find(context.booking_id)

      context.booking = BookingInProgress.find(context.booking_id) if context.booking.in_progress?
    end

    def check_participant_completeness
      context.booking.participants.each do |participant|
        participant.placeholder = participant.first_name.blank? || participant.last_name.blank?
      end
    end
  end
end
