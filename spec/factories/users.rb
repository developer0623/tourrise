# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { 'Peter' }
    last_name { 'Pan' }
    email { Faker::Internet.email }
    password { 'testtest' }
    confirmed_at { Time.zone.now }
  end
end
