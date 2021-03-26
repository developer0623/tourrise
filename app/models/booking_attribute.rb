# frozen_string_literal: true

class BookingAttribute < ApplicationRecord
  STRING = "string"
  NUMBER = "number"
  TEXT = "text"
  DATE = "date"
  DATETIME = "datetime"
  TIME = "time"
  BOOLEAN = "boolean"

  ATTRIBUTE_TYPES = [STRING, NUMBER, TEXT, DATE, DATETIME, TIME, BOOLEAN].freeze

  DEFAULT_SORT_ORDER = %w[starts_on start_time starts_at ends_on end_time ends_at reference reservation_number height pickup_location dropoff_location].freeze

  has_many :booking_attribute_values, dependent: :nullify

  belongs_to :resource_type

  validates :name, :handle, :attribute_type, presence: true
  validates :handle, uniqueness: { scope: :id, case_sensitive: false }
  validates :attribute_type, inclusion: { in: ATTRIBUTE_TYPES }

  scope :with_date_range, -> { where(handle: %i[starts_on ends_on]) }
end
