# frozen_string_literal: true

class EndsOnAfterStartsOnValidator < ActiveModel::Validator
  def validate(record)
    parsed_ends_on = parsed_ends_on(record)
    parsed_starts_on = parsed_starts_on(record)

    return unless parsed_ends_on.present?
    return unless parsed_starts_on.present?

    operator = options.fetch(:allow_same_day, false) ? ">=" : ">"

    return if parsed_ends_on.public_send(operator, parsed_starts_on)

    record.errors.add(:ends_on, I18n.t("ends_on_lt_than_starts_on", scope: %i[activerecord errors]))
  end

  private

  def parsed_starts_on(record)
    starts_on = record.starts_on

    if starts_on.is_a?(String)
      parse_date_string(record, starts_on)
    else
      starts_on
    end
  end

  def parsed_ends_on(record)
    ends_on = record.ends_on

    if ends_on.is_a?(String)
      parse_date_string(record, ends_on)
    else
      ends_on
    end
  end

  def parse_date_string(record, date_string)
    Date.parse(date_string)
  rescue ArgumentError
    record.errors.add(:ends_on, I18n.t("invalid_date_format", scope: %i[activerecord errors]))
    false
  end
end
