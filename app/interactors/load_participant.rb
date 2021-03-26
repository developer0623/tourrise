# frozen_string_literal: true

class LoadParticipant
  include Interactor

  def call
    booking = Booking.find_by(id: context.booking_id)

    context.fail!(message: :not_found) unless booking.present?

    participant = booking.participants.find_by(id: context.participant_id)

    context.fail!(message: :not_found) unless participant.present?

    context.booking = booking
    context.participant = participant
  end
end
