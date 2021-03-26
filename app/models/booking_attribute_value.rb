# frozen_string_literal: true

class BookingAttributeValue < ApplicationRecord
  belongs_to :booking_attribute, optional: true
  belongs_to :booking_resource_sku, touch: true

  validates :handle, :name, presence: true
  validates :attribute_type, inclusion: { in: BookingAttribute::ATTRIBUTE_TYPES }
  validate :value_format

  before_validation :memoize_booking_attribute_fields

  def value
    case attribute_type
    when "number"
      to_number
    when "multiselect"
      to_array
    when "date"
      to_date
    when "datetime"
      to_datetime
    when "time"
      to_time
    else
      db_value
    end
  end

  private

  def to_number
    return if db_value.blank?

    db_value.to_i
  end

  def to_array
    return if db_value.blank?

    db_value.split(",")
  end

  def to_date
    return if db_value.blank?

    Date.parse(db_value)
  end

  def to_datetime
    return if db_value.blank?

    DateTime.parse(db_value)
  end

  def to_time
    return if db_value.blank?

    Time.parse(db_value).strftime("%H:%M")
  end

  def memoize_booking_attribute_fields
    self.handle = booking_attribute.handle if booking_attribute&.handle
    self.attribute_type = booking_attribute.attribute_type if booking_attribute&.attribute_type
  end

  def db_value
    read_attribute(:value)
  end

  def value_format
    return if db_value.blank?
    return unless %w[date datetime time].include?(attribute_type)

    errors.add(:db_value, "Invalid format #{attribute_type} #{name}") unless send("valid_#{attribute_type}?")
  end

  def valid_datetime?
    DateTime.parse(db_value)
  rescue ArgumentError
    false
  end

  def valid_date?
    Date.parse(db_value)
  rescue ArgumentError
    false
  end

  def valid_time?
    Time.parse(db_value)
  rescue ArgumentError
    false
  end
end
