# frozen_string_literal: true

class AirportCodeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?

    record.errors.add(attribute, :invalid_iata_code) unless Airport.find_by_iata(value)
  end
end
