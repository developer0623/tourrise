# frozen_string_literal: true

module Frontoffice
  class DocumentPositionDecorator < Draper::Decorator
    delegate_all

    def description
      return unless object.description.present?

      starts_on = object.description["starts_on"]
      ends_on = object.description["ends_on"]

      h.distance_of_time_in_words(starts_on, ends_on) +
        " (#{h.l(starts_on, format: :short)} - #{h.l(ends_on, format: :short)})"
    end

    def price
      h.humanized_money_with_symbol(object.price)
    end

    def total_price
      h.humanized_money_with_symbol(object.total_price)
    end
  end
end
