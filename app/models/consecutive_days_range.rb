# frozen_string_literal: true

class ConsecutiveDaysRange < ApplicationRecord
  FROM_LIMIT = 0
  TO_LIMIT = 1_000

  belongs_to :resource_sku_pricing

  monetize :price_cents

  validate :any_limit?
  validate :to_greater_than_from?

  validates_numericality_of :from, only_integer: true, allow_nil: true
  validates_numericality_of :to, only_integer: true, allow_nil: true

  def from
    return FROM_LIMIT if self[:from].blank?

    read_attribute(:from)
  end

  def to
    return TO_LIMIT if self[:to].blank?

    read_attribute(:to)
  end

  def any_of_limits_blank?
    %w[from to].any? { |attr| self[attr].blank? }
  end

  def all_limits_blank?
    %w[from to].all? { |attr| self[attr].blank? }
  end

  private

  def to_greater_than_from?
    return true if any_of_limits_blank?

    errors.add :base, ":to should be greater than :from" if from > to
  end

  def any_limit?
    errors.add :base, "From or to should be present in attributes" if all_limits_blank?
  end
end
