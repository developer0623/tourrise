# frozen_string_literal: true

module Api
  module V1
    class SerializableCustomer < JSONAPI::Serializable::Resource
      type "customers"

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
