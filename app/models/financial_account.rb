# frozen_string_literal: true

class FinancialAccount < ApplicationRecord
  validates :name, :before_service_year, :during_service_year, presence: true

  def display_name
    "#{name} (#{before_service_year} - #{during_service_year})"
  end

  def for_date(starts_on: nil)
    return unless starts_on.present?

    return before_service_year if starts_on.year > Time.zone.now.year

    during_service_year
  end
end
