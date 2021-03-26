class AddReferenceParticipantTypeToParticipant < ActiveRecord::Migration[6.0]
  def change
    add_reference :participants, :participant_type, index: true
  end
end
