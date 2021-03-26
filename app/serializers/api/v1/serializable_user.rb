# frozen_string_literal: true

module Api
  module V1
    class SerializableUser < JSONAPI::Serializable::Resource
      type "users"

      attributes :id, :first_name, :last_name, :email

      link :self do
        @url_helpers.user_path(@object.id, locale: I18n.locale)
      end
    end
  end
end
