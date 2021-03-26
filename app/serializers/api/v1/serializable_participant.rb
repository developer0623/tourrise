# frozen_string_literal: true

module Api
  module V1
    class SerializableParticipant < JSONAPI::Serializable::Resource
      type "participants"

      attributes :id, :first_name, :last_name, :email

      attribute :birthdate do
        @object.birthdate.present? ? @object.birthdate.to_date.iso8601 : ""
      end

      attribute :incomplete do
        @object.placeholder?
      end
    end
  end
end
