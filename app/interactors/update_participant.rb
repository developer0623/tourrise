# frozen_string_literal: true

class UpdateParticipant
  include Interactor

  def call
    load_participant

    context.fail!(message: context.participant.errors) unless context.participant.update(context.params)

    context.participant.reload
  end

  private

  def load_participant
    load_participant_context = LoadParticipant.call(context)
    context.fail!(load_participant_context) unless load_participant_context.success?

    context.participant = load_participant_context.participant
  end
end
