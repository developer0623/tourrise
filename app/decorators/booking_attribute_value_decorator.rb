# frozen_string_literal: true

class BookingAttributeValueDecorator < Draper::Decorator
  delegate_all

  def value
    send("humanize_#{object.attribute_type}")
  end

  private

  def humanize_string
    object.value
  end

  def humanize_text
    object.value
  end

  def humanize_number
    object.value.to_i
  end

  def humanize_multiselect
    object.value.join(", ")
  end

  def humanize_date
    return unless object.value.present?

    h.l(object.value, format: :long)
  end

  def humanize_datetime
    return unless object.value.present?

    h.l(object.value.to_date, format: :long)
  end

  def humanize_time
    return unless object.value.present?

    object.value
  end
end
