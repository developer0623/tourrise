# frozen_string_literal: true

FactoryBot.define do
  factory :booking_room_assignment do
    booking

    adults    { 0 }
    kids      { 0 }
    babies    { 0 }
  end
end
