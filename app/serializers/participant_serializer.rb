# frozen_string_literal: true

class ParticipantSerializer < JSONAPI::Serializable::Resource
  type "participant"

  attributes :id,
             :first_name,
             :last_name,
             :participant_type_id,
             :birthdate,
             :placeholder,
             :email
end
