# frozen_string_literal: true

FactoryBot.define do
  factory :resource_option do
    name { Faker::Lorem.word }

    resource
  end
end
