# frozen_string_literal: true

FactoryBot.define do
  factory :financial_account do
    name { "Trip domestic" }
    before_service_year { "4444" }
    during_service_year { "3333" }
  end
end
