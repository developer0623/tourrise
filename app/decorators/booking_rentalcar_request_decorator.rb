# frozen_string_literal: true

class BookingRentalcarRequestDecorator < Draper::Decorator
  delegate_all

  def display_details
    "#{display_starts_on} - #{display_ends_on}; #{BookingRentalcarRequest.human_attribute_name(:rentalcar_class)}: #{object.rentalcar_class}"
  end

  def display_starts_on
    return unless object.starts_on.present?

    h.l(object.starts_on, format: :short)
  end

  def display_ends_on
    return unless object.ends_on.present?

    h.l(object.ends_on, format: :short)
  end
end
