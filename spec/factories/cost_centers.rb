# frozen_string_literal: true

FactoryBot.define do
  factory :cost_center do
    name { "Cost Center Name" }
    value { 10 }
  end
end
