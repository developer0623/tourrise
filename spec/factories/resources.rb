# frozen_string_literal: true

FactoryBot.define do
  factory :resource_type do
    label { 'Base' }
    sequence(:handle) { |n| "type-#{n}" }
  end

  factory :resource do
    name { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }
    resource_type { ResourceType.last || association(:resource_type) }
  end
end
