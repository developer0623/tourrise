# frozen_string_literal: true

class ResourceSkuPricing < ApplicationRecord
  monetize :price_cents
  monetize :purchase_price_cents

  enum calculation_type: { fixed: 0, per_person: 1, per_person_and_night: 2, consecutive_days: 3 }
  enum participant_type: { all_groups: 0, adult: 1, kid: 2, baby: 3 }

  belongs_to :resource_sku

  has_many :consecutive_days_ranges, dependent: :destroy
  accepts_nested_attributes_for :consecutive_days_ranges, allow_destroy: true, reject_if: :all_blank

  validates :price_cents, :calculation_type, presence: true
  validates :calculation_type, inclusion: { in: calculation_types.keys }
  validates :participant_type, inclusion: { in: participant_types.keys }, allow_blank: true
  validates :ends_on, presence: true, if: :starts_on
  validates_with EndsOnAfterStartsOnValidator, allow_same_day: true

  scope :without_date_range, -> { where(starts_on: nil, ends_on: nil) }
  scope :for_date, ->(date) { where("starts_on <= ? AND ends_on >= ?", date, date) }

  class << self
    alias adults adult
    alias kids kid
    alias babies baby
  end
end
