# frozen_string_literal: true

FactoryBot.define do
  factory :resource_option_value do
    value { Faker::Lorem.word }

    resource_option
  end
end
