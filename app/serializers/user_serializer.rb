# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id,
             :email,
             :title,
             :gender,
             :first_name,
             :last_name,
             :city,
             :zip,
             :country,
             :address_line_1,
             :address_line_2,
             :primary_phone,
             :secondary_phone,
             :created_at,
             :updated_at
end
