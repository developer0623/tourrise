# frozen_string_literal: true

FactoryBot.define do
  factory :booking_participant do
    association :booking
    association :participant
  end
end
