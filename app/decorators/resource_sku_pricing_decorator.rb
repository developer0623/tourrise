# frozen_string_literal: true

class ResourceSkuPricingDecorator < Draper::Decorator
  delegate_all

  def display_information
    [
      display_price,
      display_calculation_type,
      display_date_range,
      display_participant_type_abbr
    ].compact.join(" ")
  end

  def build_consecutive_days_range
    object.consecutive_days_ranges.new.decorate
  end

  def display_participant_type_abbr
    return unless object.participant_type.present?

    "(#{display_participant_type.first(3).upcase})"
  end

  def display_participant_type
    return h.t("frontoffice.participants.participant_types.all") unless object.participant_type.present?

    h.t("participant_types.#{object.participant_type}")
  end

  def display_calculation_type
    h.t("resource_sku_pricings.calculation_types.#{calculation_type}")
  end

  def display_date_range
    return unless starts_on.present? && ends_on.present?

    localized_starts_on = h.l(starts_on, format: :short)
    localized_ends_on = h.l(ends_on, format: :short)

    return localized_starts_on if starts_on == ends_on

    "(#{localized_starts_on} - #{localized_ends_on})"
  end

  def display_price
    h.humanized_money_with_symbol(object.price)
  end

  def available_participant_types
    ResourceSkuPricing.participant_types.map { |handle, _| [h.t("participant_types.#{handle}"), handle] }
  end

  def available_calculation_types
    ResourceSkuPricing.calculation_types.map { |handle, _| [h.t("resource_sku_pricings.calculation_types.#{handle}"), handle] }
  end
end
