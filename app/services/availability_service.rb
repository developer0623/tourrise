# frozen_string_literal: true

class AvailabilityService
  UNAVAILABLE = -1
  MIN_QUANTITY_SCORE = 1000
  MAX_QUANTITY_IN_DATE_RANGE_SCORE = MIN_QUANTITY_SCORE - 1

  attr_reader :availability

  def initialize(availability)
    @availability = availability
  end

  def available?(requested_quantity, starts_on, ends_on)
    if availability.inventory_type.to_sym == :quantity_in_date_range && (starts_on.present? && ends_on.present?)
      allocatable_amount_for_quantity_in_date_range(starts_on, ends_on)
    else
      allocatable_amount_for_quantity
    end >= requested_quantity
  end

  def score(requested_quantity, starts_on, ends_on)
    if availability.inventory_type.to_sym == :quantity_in_date_range && (starts_on.present? && ends_on.present?)
      score_for_quantity_in_date_range(starts_on, ends_on)
    else
      score_for_quantity(requested_quantity)
    end
  end

  def available_quantity(starts_on, ends_on)
    if availability.inventory_type.to_sym == :quantity_in_date_range && (starts_on.present? && ends_on.present?)
      allocatable_amount_for_quantity_in_date_range(starts_on, ends_on)
    else
      allocatable_amount_for_quantity
    end
  end

  private

  def allocatable_amount_for_quantity
    availability.quantity - availability.allocated_quantity
  end

  def allocatable_amount_for_quantity_in_date_range(starts_on, ends_on)
    return UNAVAILABLE if starts_on < availability.starts_on || ends_on > availability.ends_on

    availability.quantity - availability.allocated_quantity_in_date_range(starts_on, ends_on)
  end

  def score_for_quantity(requested_quantity)
    score = allocatable_amount_for_quantity - requested_quantity
    return UNAVAILABLE if score.negative?

    MIN_QUANTITY_SCORE + score
  end

  def score_for_quantity_in_date_range(starts_on, ends_on)
    return UNAVAILABLE unless allocatable_amount_for_quantity_in_date_range(starts_on, ends_on).positive?

    score = (starts_on - availability.starts_on).to_i + (availability.ends_on - ends_on).to_i
    return MAX_QUANTITY_IN_DATE_RANGE_SCORE if score >= MAX_QUANTITY_IN_DATE_RANGE_SCORE

    score
  end
end
