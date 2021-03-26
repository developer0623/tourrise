# frozen_string_literal: true

class BookingParticipantDecorator < Draper::Decorator
  delegate_all

  decorates_association :booking
  decorates_association :participant
  decorates_association :customer
end
