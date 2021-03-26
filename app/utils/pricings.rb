# frozen_string_literal: true

module Pricings
  STRATEGIES = [
    Pricings::Strategies::Fixed,
    Pricings::Strategies::PerPerson,
    Pricings::Strategies::PerPersonAndNight,
    Pricings::Strategies::ConsecutiveDays
  ].freeze
end
