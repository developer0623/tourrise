# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    first_name { 'John' }
    last_name  { 'Doe' }
    birthdate { 25.years.ago }
    email { Faker::Internet.email }
    primary_phone { '123740' }
    secondary_phone { '239448' }
    created_at { 1.year.ago }
  end

  factory :participant, parent: :customer, class: "Participant" do
  end
end
