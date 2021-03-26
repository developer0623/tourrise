# frozen_string_literal: true

class ConsecutiveDaysRangeDecorator < Draper::Decorator
  delegate_all

  delegate :calculation_type, :participant_type, :starts_on, :ends_on, to: :resource_sku_pricing

  def display_information
    [
      display_price,
      display_calculation_type,
      display_date_range,
      display_participant_type_abbr
    ].compact.join(" ")
  end

  def display_price
    h.humanized_money_with_symbol(object.price)
  end

  def display_calculation_type
    h.t("resource_sku_pricings.calculation_types.#{calculation_type}")
  end

  def display_date_range
    return unless starts_on.present? && ends_on.present?

    localized_starts_on = h.l(starts_on, format: :short)
    localized_ends_on = h.l(ends_on, format: :short)

    "(#{localized_starts_on} - #{localized_ends_on})"
  end

  def display_participant_type_abbr
    return unless participant_type.present?

    "(#{display_participant_type.first(3).upcase})"
  end

  def display_participant_type
    return h.t("frontoffice.participants.participant_types.all") unless participant_type.present?

    h.t("participant_types.#{participant_type}")
  end
end
