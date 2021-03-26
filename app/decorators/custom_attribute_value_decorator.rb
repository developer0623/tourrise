# frozen_string_literal: true

class CustomAttributeValueDecorator < Draper::Decorator
  delegate_all

  def pretty_value
    return if value.blank?

    case object.field_type
    when "checkbox"
      value == 1 ? I18n.t("true") : I18n.t("false")
    when "date"
      h.l(value.to_date, format: :long)
    else
      value
    end
  end

  def form_value
    return if value.blank?

    if object.field_type == "date"
      value.to_date
    else
      value
    end
  end
end
